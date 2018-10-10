import Foundation

final class NSURLSessionBasedHTTPClient: HTTPClientType {
  let urlSession: URLSession
  fileprivate var httpRequest:  HTTPRequest? = nil
  
  static let sharedInstance = NSURLSessionBasedHTTPClient(urlSession: URLSession(configuration: .default))

  init(urlSession: URLSession) {
    self.urlSession = urlSession
  }

  func run(_ request: HTTPRequest, completion: @escaping (HTTPResult) -> Void) -> HTTPTask {
    httpRequest = request
    print("\(String(describing: request.URLRequest.log()))")
    let taskCompletion: (_ d: Data?, _ r: URLResponse?, _ e: Error?) -> Void = { 
      completion(HTTPResult(data: $0, urlResponse: $1, error: $2))
    }

    let task = URLSessionTask.fromHTTPRequest(request, inSession: urlSession, withCompletion: taskCompletion)
    task.resume()
    return task
  }
}

extension URLSessionTask: HTTPTask { }

extension URLSessionTask {
  static func fromHTTPRequest(_ request: HTTPRequest, inSession urlSession: URLSession, withCompletion completion: @escaping (_ data: Data?, _ urlResponse: URLResponse?, _ error: Error?) -> Void) -> URLSessionTask {
    let urlRequest = request.URLRequest
    switch request.method {
    case .GET:
      return urlSession.dataTask(with: urlRequest, completionHandler: completion)
    case .POST:
      return urlSession.uploadTask(with: urlRequest, from: request.body, completionHandler: completion)
    case .PUT:
      return urlSession.uploadTask(with: urlRequest, from: request.body, completionHandler: completion)
    case .DELETE:
      return urlSession.dataTask(with: urlRequest, completionHandler: completion)
    }
  }
}

extension HTTPRequest {
  var URLRequest: Foundation.URLRequest {
    let result = NSMutableURLRequest(url: url)
    result.httpMethod = method.rawValue
    result.setHTTPHeaders(headers)
    result.httpShouldHandleCookies = true
    result.httpBody = body

    return result as URLRequest
  }
}

extension NSMutableURLRequest {
  func setHTTPHeaders(_ headers: [String: String]) {
    for (header, value) in headers {
      setValue(value, forHTTPHeaderField: header)
    }
  }
}

extension HTTPResponse {
  init(urlResponse: HTTPURLResponse, responseData: Data?) {
    self.statusCode = urlResponse.statusCode
    self.headers = urlResponse.stringifiedHeaderFields
    self.body = responseData
  }
}

extension HTTPURLResponse {
  var stringifiedHeaderFields: [String: String] {
    var result = [String: String]()
    for (header, value) in allHeaderFields {
      guard let
        headerString = header as? String,
        let valueString = value as? String
      else {
        continue
      }
      result[headerString] = valueString
    }
    return result
  }
}


extension HTTPResult {
  init(data: Data?, urlResponse: URLResponse?, error: Error?) {
    if let error = error {
      self = .failure(.connectionError(error as NSError))
    } else if let httpURLResponse = urlResponse as? HTTPURLResponse {
      self = HTTPResult.success(HTTPResponse(urlResponse: httpURLResponse, responseData: data))
    } else if data == nil {
      self = .failure(.unexpectedURLResponse)
    } else {
      self = .failure(.unexpectedURLResponse)
    }
//    if data == nil {
//      self = .failure(.unexpectedURLResponse)
//    }
//    else
  }
}
