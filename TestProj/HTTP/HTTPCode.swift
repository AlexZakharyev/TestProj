//
//  HTTPCode.swift
//  BLOK
//
//  Created by Aleksandr on 09.10.17.
//  Copyright © 2017 Nixsolutions. All rights reserved.
//

import Foundation

enum HTTPCode: Int {
  case unautorize = 401
  case conflict = 409
  case notFound = 404
  case internalServerError = 500
}
