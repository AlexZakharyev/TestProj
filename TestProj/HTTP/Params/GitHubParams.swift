//
//  GitHubParams.swift
//  TestProj
//
//  Created by Aleksandr on 09.10.2018.
//  Copyright © 2018 qqq. All rights reserved.
//

import Foundation

struct GitHubParams {
  let q: String
  let sort: String
  let order: String
  let page: Int
  let perPage: Int
}

extension GitHubParams: BodyObjectEncodable {
  func encode() -> BodyObject {
    let result: JSONObject = [
      "q": q,
      "sort": sort,
      "order": order,
      "page": page,
      "per_page": perPage
    ]
    
    return BodyObject.jsonEncodable(result)
  }
}
