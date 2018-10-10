//
//  MultipartItem.swift
//  BLOK
//
//  Created by Anton Hudz on 10/11/17.
//  Copyright © 2017 Nixsolutions. All rights reserved.
//

import UIKit

typealias MultipartObject = Data

enum MultipartItemType {
  case imageItem
  case textItem
}

struct MultipartItem {

  static let compressionQuality: CGFloat = 0.65

  var mimeType: String
  var content: String
  var itemKey: String
  var dispositionItem: String
  var multipartItemType: MultipartItemType

  init(withImage content: String, itemKey: String, imageName: String) {
    let mimetype = "image/jpeg"
    self.content = content
    self.mimeType = "Content-Type: \(mimetype)\r\n\r\n"
    self.itemKey = itemKey
    self.dispositionItem = "Content-Disposition:form-data; name=\"\(itemKey)\"; filename=\"\(imageName)\"\r\n"
    self.multipartItemType = .imageItem
  }

  init(withText content: String, itemKey: String) {
    self.content = content
    self.mimeType = "Content-Type: \"text/plain\"\r\n"
    self.itemKey = itemKey
    self.dispositionItem = "Content-Disposition:form-data; name=\"\(itemKey)\"\r\n\r\n"
    self.multipartItemType = .textItem
  }
}
