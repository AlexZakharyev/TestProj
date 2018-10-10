import Foundation

struct HeaderFields {
  let authorization: String?
}

extension HeaderFields {
  func encode() -> [String: String] {
    if let authorization = authorization {
      return ["Authorization": authorization]
    } else {
      return [:]
    }
  }
}
