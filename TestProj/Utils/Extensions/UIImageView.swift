//
//  UIImageView.swift
//  TestProj
//
//  Created by zakhariev on 10/9/18.
//  Copyright © 2018 qqq. All rights reserved.
//

import Foundation
import SDWebImage

extension UIImageView {
  func load(_ url: URL?, defaultImage: UIImage?) {
    if let url = url {
      print(url.absoluteString)
      SDWebImageDownloader.shared().setValue("text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
                                             forHTTPHeaderField: "Accept")
      
      sd_setImage(with: url, placeholderImage: defaultImage,
                  options: .retryFailed)
    }
  }
  
  func circleAnimation() {
    guard layer.animation(forKey: "rotation") == nil else { return }
    
    let animation = CABasicAnimation(keyPath: "transform.rotation.z")
    animation.duration = 1
    animation.toValue = 0.0
    animation.byValue = Double.pi * 2
    animation.repeatCount = Float(INT_MAX)
    
    layer.add(animation, forKey: "rotation")
  }
}

