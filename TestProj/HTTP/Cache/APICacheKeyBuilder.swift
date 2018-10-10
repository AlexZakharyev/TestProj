import Foundation

protocol APICacheKeyBuilderType {
  func build<T>(withRoute route: APIRoute<T>) -> String
}

class DefaultAPICacheKeyBuilder: APICacheKeyBuilderType {
  private let pathBuilder: APIPathBuilder
  private let builder: APIParametersBuilder
  
  init(pathBuilder: APIPathBuilder, builder: APIParametersBuilder) {
    self.pathBuilder = pathBuilder
    self.builder = builder
  }
  
  func build<T>(withRoute route: APIRoute<T>) -> String {
    let path = pathBuilder.buildPath(withMethod: route.method)
    let encodedQuery = builder.queryEncode(forRoute: route)
    return path + (encodedQuery ?? "")
  }
}
