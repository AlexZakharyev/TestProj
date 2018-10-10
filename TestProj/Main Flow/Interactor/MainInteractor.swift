//
//  MainInteractor.swift
//  TestProj
//
//  Created by zakhariev on 10/9/18.
//  Copyright © 2018 qqq. All rights reserved.
//

import Foundation

protocol MainInteractorType {
  func loadGitHubRepos(page: Int,
                       withCache: Bool,
                       success: @escaping (_ result: GitHubResult) -> Void,
                       failure: FailureCompletion?)
}

final class MainInteractor: MainInteractorType {
  fileprivate let gateway: APIGateway<GitHubResult>
  fileprivate let route: (_ params: GitHubParams) -> APIRoute<GitHubResult>
  
  init(gateway: APIGateway<GitHubResult>,
       route: @escaping (_ params: GitHubParams) -> APIRoute<GitHubResult>) {
    self.gateway = gateway
    self.route = route
  }
  
  deinit {
    cancel()
  }
  
  func loadGitHubRepos(page: Int,
                       withCache: Bool,
                       success: @escaping (_ result: GitHubResult) -> Void,
                       failure: FailureCompletion?) {
    let params = GitHubParams(q: "tetris+language:assembly",
                              sort: "stars",
                              order: "desc",
                              page: page,
                              perPage: 30)
    DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
      self.gateway.request(route: self.route(params), useCache: withCache, handler: { result in
        switch result {
        case .success(var data):
          DispatchQueue.main.async {
            data.updatePage(page)
            success(data)
          }
        case .failure(let error):
          DispatchQueue.main.async {
            failure?(error)
          }
        }
      })
    }
  }
}

extension MainInteractor {
  func cancel() {
    gateway.cancel()
  }
}
