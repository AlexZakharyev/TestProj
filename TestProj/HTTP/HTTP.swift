import Foundation

enum HTTPMethod: String {
  case GET
  case POST
  case PUT
  case DELETE
}

struct HTTPRequest: Equatable {
  let method: HTTPMethod
  let url: URL
  let headers: [String: String]
  let body: Data?
}

func ==(lhs: HTTPRequest, rhs: HTTPRequest) -> Bool {
  return (lhs.method == rhs.method)
      && (lhs.url == rhs.url)
      && (lhs.headers == rhs.headers)
      && (lhs.body == rhs.body)
}

extension HTTPRequest: CustomDebugStringConvertible {
  var debugDescription: String {
    return self.URLRequest.debugDescription
  }
}

struct HTTPResponse: Equatable {
  let statusCode: Int
  let headers: [String: String]
  let body: Data?
}

func ==(lhs: HTTPResponse, rhs: HTTPResponse) -> Bool {
  return (lhs.statusCode == rhs.statusCode)
      && (lhs.headers == rhs.headers)
      && (lhs.body == rhs.body)
}

enum HTTPClientError: Error, Equatable {
  case connectionError(NSError)
  case unexpectedURLResponse
}

func ==(lhs: HTTPClientError, rhs: HTTPClientError) -> Bool {
  switch (lhs, rhs) {
    case (.connectionError(let lhs), .connectionError(let rhs)):
      return lhs == rhs
    case (.unexpectedURLResponse, .unexpectedURLResponse):
      return true
    default:
      return false
  }
}

enum HTTPResult: Equatable {
  case success(HTTPResponse)
  case failure(HTTPClientError)
}

func ==(lhs: HTTPResult, rhs: HTTPResult) -> Bool {
  switch (lhs, rhs) {
  case (.success(let lhs), .success(let rhs)):
    return lhs == rhs
  case (.failure(let lhs), .failure(let rhs)):
    return lhs == rhs
  default:
    return false
  }
}

func percentEncodeQuery(_ key: String, object: AnyObject) -> String? {
  if key.isEmpty { return nil }
  let value: AnyObject
  if let object = object as? String {
    let characterSet = NSMutableCharacterSet.alphanumeric()
//    let allowedCharacters = NSCharacterSet(charactersIn:" =\"#%/<>?@\\^`{}[]|&").inverted
//    characterSet.formUnion(with: allowedCharacters)
    characterSet.addCharacters(in: "_")
    characterSet.addCharacters(in: ".")
    characterSet.addCharacters(in: "&")
    characterSet.addCharacters(in: "[]")
    characterSet.addCharacters(in: "]")
    characterSet.addCharacters(in: "[")
    
    guard let objectPercentEncoding = object.addingPercentEncoding(withAllowedCharacters: characterSet as CharacterSet) else { return nil }
    value = objectPercentEncoding as AnyObject
  } else {
    value = object
  }
  return "\(key)=\(value)"
}

func makeArrayURL(_ key: String, object: AnyObject) -> String? {
  guard let values = object as? [AnyObject] else { return nil }
  var urlString: String = ""
  let andAPIKey = "&" + key
  guard let encodedKey = encodeKey(andAPIKey) else { return nil }
  values.forEach { value in
    if let encoded = percentEncodeQuery(encodedKey, object: value as AnyObject) {
      urlString += encoded
    }
  }
  urlString.removeFirst()

  return urlString
}

private func encodeKey(_ key: String) -> String? {
  let characterSet = NSMutableCharacterSet.alphanumeric()
  characterSet.addCharacters(in: "_")
  characterSet.addCharacters(in: ".")
  characterSet.addCharacters(in: "&")
  guard let keyPercentEncoding = key.addingPercentEncoding(withAllowedCharacters: characterSet as CharacterSet) else { return nil }
  return keyPercentEncoding
}

struct BoundaryConstant {
  static let boundary = "Boundary-\(UUID().uuidString)"
}
