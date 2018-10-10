//
//  MultipartBuilder.swift
//  BLOK
//
//  Created by Anton Hudz on 10/11/17.
//  Copyright © 2017 Nixsolutions. All rights reserved.
//

import Foundation

protocol MultipartBuilderType {
  func makeMultipartWith(items: [MultipartItem]) -> MultipartObject?
}

final class MultipartBuilder: MultipartBuilderType {
  func makeMultipartWith(items: [MultipartItem]) -> MultipartObject? {
    var body = Data()
    body = self.createMultiPartBody(&body, items)
    return body as MultipartObject
  }

  private func createMultiPartBody(_ body: inout Data, _ items: [MultipartItem]) -> Data {
    var sortedItems: [String: [MultipartItem]] = Dictionary()

    for item: MultipartItem in items {
      let mimeType = item.mimeType
      var arrayForMimeType = self.arrayPointerForMimeType(mimeType, inDictionary: &sortedItems)
      arrayForMimeType.append(item)
      sortedItems[mimeType] = arrayForMimeType
    }

    for (mimeType, multiPartItems) in sortedItems {
      body = self.makeBody(body: &body, mimeType, multiPartItems)
    }

    body.append("--\(BoundaryConstant.boundary)--\r\n".data(using: String.Encoding.utf8)!)

    return body
  }

  private func arrayPointerForMimeType(_ mimeType: String, inDictionary: inout [String: [MultipartItem]]) -> [MultipartItem] {
    let keys = inDictionary.keys
    if keys.contains(mimeType) {
      return inDictionary[mimeType]!
    }

    inDictionary[mimeType] = Array()
    return inDictionary[mimeType]!
  }

  private func makeBody(body: inout Data, _ mimeType: String, _ multiPartItems: [MultipartItem]) -> Data {
    if mimeType == "Content-Type: image/jpeg\r\n\r\n" {
      body = self.makeBodyImage(body: &body, multiPartItems, mimeType)
    }
    else {
      body = self.makeBodyTextPlain(body: &body, multiPartItems, mimeType)
    }

    return body
  }

  private func makeBodyImage(body: inout Data, _ multiPartItems: [MultipartItem], _ mimeType: String) -> Data {
    for mItem: MultipartItem in multiPartItems {
      body.append("--\(BoundaryConstant.boundary)\r\n".data(using: String.Encoding.utf8)!)
      body.append(mItem.dispositionItem.data(using: String.Encoding.utf8)!)
      body.append(mimeType.data(using: String.Encoding.utf8)!)
      let decodedData = Data(base64Encoded: mItem.content, options: .ignoreUnknownCharacters)
      body.append(decodedData!)
      body.append("\r\n".data(using: String.Encoding.utf8)!)
    }

    return body
  }

  private func makeBodyTextPlain(body: inout Data, _ multiPartItems: [MultipartItem], _ mimeType: String) -> Data {
    body.append(mimeType.data(using: String.Encoding.utf8)!)

    for mItem: MultipartItem in multiPartItems {
      body.append("--\(BoundaryConstant.boundary)\r\n".data(using: String.Encoding.utf8)!)
      body.append(mItem.dispositionItem.data(using: String.Encoding.utf8)!)
      body.append(mItem.content.data(using: String.Encoding.utf8)!)
      body.append("\r\n".data(using: String.Encoding.utf8)!)
    }

    return body
  }
}
