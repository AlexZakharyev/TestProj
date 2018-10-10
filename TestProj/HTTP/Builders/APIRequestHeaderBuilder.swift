import Foundation

class APIRequestHeaderBuilder: APIRequestHeaderBuilderType {
  static let sharedInstance = APIRequestHeaderBuilder()
  
  func makeHeaderFields() -> HeaderFields {
    let authHeaderField: String? = ""
//
//    if let token = userManager.getUserApiToken() {
//      authHeaderField = "Bearer \(token)"
//    }
    
    return HeaderFields(authorization: authHeaderField)
  }

}
