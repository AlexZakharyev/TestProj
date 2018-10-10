import Foundation

protocol APIParametersBuilder {
  func queryEncode<T>(forRoute route: APIRoute<T>) -> Query?
}

class DefaultAPIParametersBuilder: APIParametersBuilder {
  func queryEncode<T>(forRoute route: APIRoute<T>) -> Query? {
    switch route.httpMethod {
    case .GET: return queryEncode(forMethod: route.method, params: route.params)
    default: return nil
    }
  }
  
  fileprivate func queryEncode(forMethod method: String, params: BodyObjectEncodable?) -> Query? {
    guard let queryParams = params?.encode() else { return nil }
    switch queryParams {
    case .jsonEncodable(let paramsQuery):
      let query = paramsQuery.sorted(by: { $0.0<$1.0 }).compactMap {
        if $0.0.contains("[]") {
          return makeArrayURL($0.0, object: $0.1 as AnyObject)
        } else {
          return percentEncodeQuery($0.0, object: $0.1 as AnyObject)
        }
      }.joined(separator: "&")
      return query
    default:
      return nil
    }
  }
}
