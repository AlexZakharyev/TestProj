import Foundation

protocol APIMethodBuilderType {
  associatedtype T: JSONObjectDecodable
  func build(route: APIRoute<T>) -> APIMethod<T>
}

class APIMethodBuilder<T: JSONObjectDecodable>: APIMethodBuilderType {
  
  fileprivate let cacheKeyBuilder: APICacheKeyBuilderType
  fileprivate let pathBuilder: APIPathBuilder
  fileprivate let paramsBuilder: APIParametersBuilder
  fileprivate let bodyBuilder: APIBodyBuilderType
  fileprivate let requestHeaderBuilder: APIRequestHeaderBuilderType
  
  init(pathBuilder: APIPathBuilder,
       paramsBuilder: APIParametersBuilder,
       bodyBuilder: APIBodyBuilderType,
       requestHeaderBuilder: APIRequestHeaderBuilderType,
       cacheKeyBuilder: APICacheKeyBuilderType) {
    self.pathBuilder = pathBuilder
    self.paramsBuilder = paramsBuilder
    self.bodyBuilder = bodyBuilder
    self.requestHeaderBuilder = requestHeaderBuilder
    self.cacheKeyBuilder = cacheKeyBuilder
  }
  
  func build(route: APIRoute<T>) -> APIMethod<T> {
    let path = pathBuilder.buildPath(withMethod: route.method)
    let query = paramsBuilder.queryEncode(forRoute: route)
    let body = bodyBuilder.build(forRoute: route)
    let headerFields = requestHeaderBuilder.makeHeaderFields()
    
    return APIMethod(cacheKey: cacheKeyBuilder.build(withRoute: route),
                     httpMethod: route.httpMethod,
                     path: path,
                     percentEncodedQuery: query,
                     body: body,
                     resultParser: route.parser,
                     headerFields: headerFields)
  }
}
