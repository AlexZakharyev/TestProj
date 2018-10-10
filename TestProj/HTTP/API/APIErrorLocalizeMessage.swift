//
//  APIErrorLocalizeMessage.swift
//  BLOK
//
//  Created by Aleksandr on 09.10.17.
//  Copyright © 2017 Nixsolutions. All rights reserved.
//

import Foundation

func localizedMessageForError(errorCode: APIError) -> String {
  switch errorCode {
  case .unautorized:
    return ""
  case .internetNotAvailable:
    return ""
  case .conflict:
    return "Can't perform action"
  case .parseMessageResponseError(let message):
    return message
  case .connectionRefused:
    return "Connection refused. Please try again."
  default:
    return ""
  }
}
