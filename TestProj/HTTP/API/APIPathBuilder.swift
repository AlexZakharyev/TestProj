import Foundation

protocol APIPathBuilder {
  func buildPath(withMethod method: String) -> String
}

class DefaultAPIPathBuilder: APIPathBuilder {
  func buildPath(withMethod method: String) -> String {
    return "/\(method)"
  }
}
