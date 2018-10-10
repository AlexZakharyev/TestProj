//
//  RepositoryViewModel.swift
//  TestProj
//
//  Created by zakhariev on 10/9/18.
//  Copyright © 2018 qqq. All rights reserved.
//

import UIKit

struct RepositoryViewModel {
  let avatarURL: URL
  let size: String
  let login: String
  let fullName: String
  let description: String
  let imageProportionsize: Int
  
  init?(model: RepositoryModel?, maxSize: Int?) {
    guard let model = model,
          let url = model.owner?.avatar,
          let avatarURL = URL(string: url),
          let login = model.owner?.login
      else {
        return nil
    }
    self.avatarURL = avatarURL
    self.size = "\(String(format: "%.2f", Float(model.size) / 1024)) Mb"
    self.login = login
    self.fullName = model.fullName
    self.description = model.description
    if let maxSize = maxSize, maxSize != 0 {
      self.imageProportionsize = Int(120 * (1 + Float(model.size) / Float(maxSize)))
    } else {
      self.imageProportionsize = 120
    }
  }
}
