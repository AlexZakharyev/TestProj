//
//  StatusCodeObject.swift
//  BLOK
//
//  Created by Aleksandr on 28.09.17.
//  Copyright © 2017 Nixsolutions. All rights reserved.
//

import Foundation

struct StatusCodeObject {
  let statusCode: Int
}

extension StatusCodeObject: JSONObjectDecodable {
  init?(jsonObject: JSONObject) {
    return nil
  }
}

extension StatusCodeObject: APIResult {}

extension StatusCodeObject: Equatable {}
func ==(lhs: StatusCodeObject, rhs: StatusCodeObject) -> Bool {
  return lhs.statusCode == rhs.statusCode
}
