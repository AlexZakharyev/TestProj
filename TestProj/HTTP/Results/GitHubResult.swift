//
//  GitHubResult.swift
//  TestProj
//
//  Created by Aleksandr on 09.10.2018.
//  Copyright © 2018 qqq. All rights reserved.
//

import Foundation

struct GitHubResult {
  private(set) var incompleteResults: Int
  private(set) var items: [RepositoryModel]
  private(set) var totalCount: Int
  private(set) var currentPage: Int = 0
}

extension GitHubResult: JSONObjectDecodable {
  init?(jsonObject: JSONObject) {
    print(jsonObject)
    self.incompleteResults = jsonObject.incomplete_results ?? 0
    self.totalCount = jsonObject.total_count ?? 0
    
    if let reposItems: JSONArrayOfJSONObjects = jsonObject.items {
      self.items = reposItems.compactMap { RepositoryModel(jsonObject: $0) }
    } else {
      self.items = []
    }
  }
  
  mutating func append(model: GitHubResult) {
    self.incompleteResults = model.incompleteResults
    self.items += model.items
    self.totalCount = model.totalCount
  }
  
  mutating func remove(_ model: RepositoryModel?) {
    guard let model = model, let index = items.firstIndex(of: model) else { return }
    items.remove(at: index)
  }
  
  mutating func updatePage(_ page: Int) {
    self.currentPage = page
  }
}

extension GitHubResult: Equatable {}
func ==(lhs: GitHubResult, rhs: GitHubResult) -> Bool {
  return true
}

extension GitHubResult: APIResult {}


struct RepositoryModel {
  let id: String
  let size: Int
  let owner: OwnerModel?
  let fullName: String
  let description: String
}

extension RepositoryModel: JSONObjectDecodable {
  init?(jsonObject: JSONObject) {
    print(jsonObject)
    //owner -> avatar_url
    self.id = jsonObject.id ?? ""
    self.size = jsonObject.size ?? 0
    
    self.owner = OwnerModel(jsonObject: jsonObject.owner ?? [:])
    self.fullName = jsonObject.full_name ?? ""
    self.description = jsonObject["description"] as? String ?? ""
  }
}

extension RepositoryModel: Equatable {}
func ==(lhs: RepositoryModel, rhs: RepositoryModel) -> Bool {
  return true
}

struct OwnerModel {
  let id: String
  let avatar: String
  let login: String
}

extension OwnerModel: JSONObjectDecodable {
  init?(jsonObject: JSONObject) {
    print(jsonObject)
    self.id = jsonObject.id ?? ""
    self.avatar = jsonObject.avatar_url ?? ""
    self.login = jsonObject.login ?? ""
  }
}

extension OwnerModel: Equatable {}
func ==(lhs: OwnerModel, rhs: OwnerModel) -> Bool {
  return true
}


