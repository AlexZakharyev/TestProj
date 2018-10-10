import Foundation

extension URLRequest {
  
  fileprivate func cURLRepresentation() -> String {
    var cURL = "curl"
    var headers: [(String, String)] = []
    
    guard let URL = url else {
      return "$ curl command could not be created"
    }

    if let httpHeadert = allHTTPHeaderFields {
      for (field, value) in httpHeadert {
        headers.append((field, value))
      }
    }
    headers.sort{$0.0<$1.0}
    for (field, value) in headers {
      cURL += " -H \"\(field): \(value)\""
    }

    cURL += " " + "\"\(URL.absoluteString)\""
    
    return cURL
  }
  
  public var сurlDescription: String {
    return cURLRepresentation()
  }
  
  func log() -> String {
    return self.сurlDescription
  }
}

