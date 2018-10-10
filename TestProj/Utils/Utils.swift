//
//  Utils.swift
//  BLOK
//
//  Created by Aleksandr Zakhariev on 8/3/17.
//  Copyright © 2017 Nixsolutions. All rights reserved.
//

import UIKit

var onePixel: CGFloat = 1 / UIScreen.main.scale

struct TimeConstants {
  static let Minute: Double = 60
  static let Hour: Double = 60 * TimeConstants.Minute
  static let Day: Double = 24 * TimeConstants.Hour
  static let Week: Double = 7 * TimeConstants.Day
}

enum StoryboardName: String {
  case main = "Main"
}

// MARK: HTTP
typealias FailureCompletion = ((APIError) -> Void)
typealias EmptyCompletion = () -> Void
