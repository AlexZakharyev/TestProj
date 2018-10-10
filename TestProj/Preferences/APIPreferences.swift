import Foundation

final class APIPreferences {
  var clientSecret: String {
    return ""
  }
  
  var clientId: String {
    return ""
  }
  
  var socketURL: URL {
    return URL(string: "")!
  }

  let platform = "ios"

  // MARK: - Domain
  var domain: String {
    return "\(scheme)://\(host)"
  }
  
  fileprivate var host: String {
    return "api.github.com"
  }

  fileprivate var scheme: String {
    return "https"
  }

  func apiConfiguration() -> APIConfiguration {
    print(scheme + ", " + host)
    return APIConfiguration(scheme: scheme,
                              host: host)
  }
}
