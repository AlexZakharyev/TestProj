//
//  MainAdapter.swift
//  TestProj
//
//  Created by zakhariev on 10/9/18.
//  Copyright © 2018 qqq. All rights reserved.
//

import Foundation

protocol MainAdapterType {
  var onLoadMore: ((Int) -> Void)? { get set }
  var onDisableRandomBtn: EmptyCompletion? { get set }
  var randomRepository: RepositoryViewModel? { get }
  
  func setModel(_ model: GitHubResult)
}

final class MainAdapter: MainAdapterType {
  fileprivate var model: GitHubResult?
  
  var onLoadMore: ((Int) -> Void)?
  var onDisableRandomBtn: EmptyCompletion?
  var randomRepository: RepositoryViewModel? {
    let randomModel = model?.items.randomElement()
    model?.remove(randomModel)
    loadMoreIfNeeded()
    let maxRepos = model?.items.max(by: { $0.size < $1.size })
    return RepositoryViewModel(model: randomModel, maxSize: maxRepos?.size)
  }

  func setModel(_ model: GitHubResult) {
    self.model = model
  }
  
  fileprivate func loadMoreIfNeeded() {
    guard let itemsCount = model?.items.count else { return }
    if itemsCount == 0 {
      onDisableRandomBtn?()
    }
    
    if let currentPage = model?.currentPage, itemsCount < 3 {
      onLoadMore?(currentPage + 1)
    }
  }
}
