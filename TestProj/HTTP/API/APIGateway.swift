import Foundation

protocol APIGatewayType {
  associatedtype T: APIResult
  func request(route: APIRoute<T>, useCache: Bool, handler: @escaping (Result<T, APIError>) -> Void)
  func cancel()
}

protocol APIResult: JSONObjectDecodable, Equatable {}

class APIGateway<T: APIResult>: APIGatewayType {
  fileprivate let client: AnyAPIClient<T>
  fileprivate let methodBuilder: APIMethodBuilder<T>
  fileprivate var route: APIRoute<T>?
  
  init(client: AnyAPIClient<T>,
       methodBuilder: APIMethodBuilder<T>) {
    self.client = client
    self.methodBuilder = methodBuilder
  }
  
  deinit {
    cancel()
  }
  
  func request(route: APIRoute<T>, useCache: Bool, handler: @escaping (Result<T, APIError>) -> Void) {
    self.route = route
    let method = methodBuilder.build(route: route)
    execute(method: method, useCache: useCache, handler: handler)
  }
  
  fileprivate func execute(method: APIMethod<T>, useCache: Bool, handler: @escaping (Result<T, APIError>) -> Void) {
    client.execute(method, useCache: useCache) { result in
      switch result {
      case .success(let apiResult):
        handler(.success(apiResult))
      case .failure(let error):
            handler(.failure(error))
      }
    }
  }
  
  func cancel() {
    client.cancel()
  }
}
