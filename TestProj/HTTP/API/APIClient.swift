import Foundation

protocol APIClientType {
  associatedtype ProvidedResultType: Equatable
  func execute(_ method: APIMethod<ProvidedResultType>, useCache: Bool, handler: @escaping (Result<ProvidedResultType, APIError>) -> Void)
  func cancel()
}

struct AnyAPIClient<ProvidedResultType: Equatable>: APIClientType {
  fileprivate let executeClosure: (APIMethod<ProvidedResultType>, _ useCache: Bool, _ handler: @escaping (Result<ProvidedResultType, APIError>) -> Void) -> Void
  fileprivate let cancelClosure: () -> Void

  init<ClientType: APIClientType>(_ client: ClientType) where ProvidedResultType == ClientType.ProvidedResultType {
    self.executeClosure = client.execute
    self.cancelClosure = client.cancel
  }

  func execute(_ method: APIMethod<ProvidedResultType>, useCache: Bool, handler: @escaping (Result<ProvidedResultType, APIError>) -> Void) {
    executeClosure(method, useCache, handler)
  }

  func cancel() {
    cancelClosure()
  }
}

class APIClient<ProvidedResultType: Equatable>: APIClientType {
  fileprivate let httpClient: HTTPClientType
  fileprivate let configuration: APIConfiguration
  fileprivate var httpTask: HTTPTask?
  fileprivate let cache: APICacheStorageType
  fileprivate let networkActivityIdicator = NetworkActivityIndicator.shared()
  fileprivate var runningRequests: [String] = []
  
  init(httpClient: HTTPClientType, configuration: APIConfiguration, cache: APICacheStorageType) {
    self.httpClient = httpClient
    self.configuration = configuration
    self.cache = cache
  }

  func execute(_ method: APIMethod<ProvidedResultType>, useCache: Bool, handler: @escaping (Result<ProvidedResultType, APIError>) -> Void) {
    networkActivityIdicator.start()
    
    if useCache, let cachedJSONObject = cache.object(for: method.cacheKey) {
      networkActivityIdicator.end()
      handler(extractAPIResponse(cachedJSONObject, parser: method.resultParser, cacheKey: method.cacheKey))
    }
    
    if runningRequests.contains(method.cacheKey) {
      return
    } else {
      runningRequests.append(method.cacheKey)
    }
    
    httpTask = httpClient.run(convertAPIMethodToHTTPRequest(method)) { [unowned self] result in
      self.networkActivityIdicator.end()
      if let index = self.runningRequests.index(of: method.cacheKey) {
        self.runningRequests.remove(at: index)
      }
      switch result {
      case .success(let response):
        self.handleResult(response.body, statusCode: response.statusCode, method: method, useCache: useCache, handler: handler)
        
      case .failure(let error):
        switch error {
        case .connectionError(let ce): handler(.failure(.clientError(ce)))
        case .unexpectedURLResponse:   handler(.failure(.unknownError))
        }
      }
    }
  }
  
  fileprivate func makeHeaders(_ method: APIMethod<ProvidedResultType>) -> [String: String] {
    var headers = method.headerFields.encode()
    
    headers["Accept"] = "application/json"
    guard let methodBody = method.body else { return headers }
    switch methodBody {
    case .jsonEncodable:
      headers["Content-Type"] = "application/json"
      return headers
    case .multipartEncodable:
      headers["Content-Type"] = "multipart/form-data; boundary=\(BoundaryConstant.boundary)"
      return headers
    }
  }

  func cancel() {
    networkActivityIdicator.end()
    httpTask?.cancel()
    httpTask = nil
  }

  fileprivate func convertAPIMethodToHTTPRequest(_ method: APIMethod<ProvidedResultType>) -> HTTPRequest {
    return HTTPRequest(
      method: method.httpMethod,
      url: resolveFullURL(method),
      headers: makeHeaders(method),
      body: makeBody(method)
    )
  }

  fileprivate func resolveFullURL(_ method: APIMethod<ProvidedResultType>) -> URL {
    var urlComponents = URLComponents()
    urlComponents.scheme = configuration.scheme
    urlComponents.host = configuration.host
    urlComponents.path = method.path
    urlComponents.percentEncodedQuery = method.percentEncodedQuery
    let url = urlComponents.url

    return url!
  }

  fileprivate func makeBody(_ method: APIMethod<ProvidedResultType>) -> Data? {
    guard let body = method.body else { return nil }
    switch body {
    case .jsonEncodable(let param):
      let body: JSONObject = param
      let jsonData = try? encodeJSON(body)
      return jsonData
    case .multipartEncodable(let param):
      return param
    }
  }

  fileprivate func handleResult(_ body: Data?,
                                statusCode: Int,
                                method: APIMethod<ProvidedResultType>,
                                useCache: Bool,
                                handler: (Result<ProvidedResultType, APIError>) -> Void) {
    guard let data = body, let json = try? decodeJSON(data: data), let jsonObject = json as? JSONObject else {
      if let error = handleStatusCode(statusCode) {
        return handler(error)
      }
      
      return handler(defaultAPIResponse(with: statusCode))
    }
    
    if let error = handleStatusCode(statusCode) {
      return handler(error)
    }

    handler(self.extractAPIResponse(jsonObject, parser: method.resultParser, cacheKey: method.cacheKey))
  }
  
  fileprivate func handleStatusCode(_ statusCode: Int) -> Result<ProvidedResultType, APIError>?{
    if (400 ... 500).contains(statusCode) {
      let error = reedStatusCode(codeStatus: statusCode)
      
      return .failure(error)
    }
    return nil
  }
  
  fileprivate func extractAPIResponse(_ jsonObject: JSONObject,
                                      parser: (JSONObject) -> ProvidedResultType?,
                                      cacheKey: String) -> Result<ProvidedResultType, APIError> {
    if let result = parser(jsonObject) {      
      if let cachedJSONObject = cache.object(for: cacheKey) {
        if cachedJSONObject != jsonObject {
          cache.set(object: jsonObject, forKey: cacheKey)
        }
      } else {
        cache.set(object: jsonObject, forKey: cacheKey)
      }
      
      return .success(result)
    } else if let failureMessage = jsonObject["message"] as? String, !failureMessage.isEmpty {
      return .failure(.parseMessageResponseError(message: failureMessage))
    }
    
    return .failure(.couldNotParseResponse)
  }
  
  fileprivate func defaultAPIResponse(with statusCode: Int) -> Result<ProvidedResultType, APIError> {
    guard let statusCodeObject = StatusCodeObject(statusCode: statusCode) as? ProvidedResultType else {
      return .failure(.couldNotParseResponse)
    }
    
    return .success(statusCodeObject)
  }
}
