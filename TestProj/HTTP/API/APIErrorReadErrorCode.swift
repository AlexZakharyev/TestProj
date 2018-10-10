//
//  APIErrorReadErrorCode.swift
//  BLOK
//
//  Created by Aleksandr on 09.10.17.
//  Copyright © 2017 Nixsolutions. All rights reserved.
//

import Foundation

func reedStatusCode(codeStatus: Int?) -> APIError {
  guard let codeStatus = codeStatus else { return .unknownError }
  switch codeStatus {
  case HTTPCode.unautorize.rawValue:
    return .unautorized
  case HTTPCode.internalServerError.rawValue:
    return .parseMessageResponseError(message: "Internal Server Error")
  case HTTPCode.conflict.rawValue:
    return .conflict
  case HTTPCode.notFound.rawValue:
    return .notFound
  default:
    return .unknownError
  }
}
