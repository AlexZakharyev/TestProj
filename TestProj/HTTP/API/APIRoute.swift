import Foundation

enum APIRoute<T: JSONObjectDecodable> {
  case getGitRepos(params: GitHubParams)
  
  var method: String {
    switch self {
    case .getGitRepos: return "search/repositories"
    }
  }
  
  var httpMethod: HTTPMethod {
    switch self {
    
    default: return .GET
    }
  }
 
  var params: BodyObjectEncodable? {
    switch self {
      case .getGitRepos(let params): return params
    }
  }
  
  var parser: (JSONObject) -> T? {
    return T.init
  }
}

func apiRouteGetGitRepos<T>(_ params: GitHubParams) -> APIRoute<T> {
  return .getGitRepos(params: params)
}
