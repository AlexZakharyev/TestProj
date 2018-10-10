import Foundation

enum BodyObject {
  case jsonEncodable(JSONObject)
  case multipartEncodable(MultipartObject)
}

protocol BodyObjectEncodable {
  func encode() -> BodyObject
}

protocol APIBodyBuilderType {
  func build<T>(forRoute route: APIRoute<T>) -> BodyObject?
}

final class DefaultAPIBodyBuilder: APIBodyBuilderType {
  func build<T>(forRoute route: APIRoute<T>) -> BodyObject? {
    switch route.httpMethod {
    case .PUT: return route.params?.encode()
    case .POST: return route.params?.encode()
    case .DELETE: return route.params?.encode()
    default: return nil
    }
  }
}

extension DefaultAPIBodyBuilder {
  fileprivate func appendData(forValue value: AnyObject, key: String) -> Data {
    let data = NSMutableData()

    guard let value = value as? String else { return data as Data }

    data.append(beginline.data(using: String.Encoding.utf8)!)
    data.append("Content-Disposition:form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
    data.append("\(value)".data(using: String.Encoding.utf8)!)
    data.append(endline.data(using: String.Encoding.utf8)!)

    return data as Data
  }
}

extension DefaultAPIBodyBuilder {
  fileprivate var stringBoundary: String {
    return BoundaryConstant.boundary
  }

  fileprivate var beginline: String {
    return "--\(stringBoundary)\r\n"
  }

  fileprivate var endline: String {
    return "\r\n"
  }

  fileprivate var lastlineData: Data {
    return "--\(stringBoundary)--\r\n".data(using: String.Encoding.utf8)!
  }
}
