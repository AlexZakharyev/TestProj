//
//  NetworkActivityIndicator.swift
//  Randevu
//
//  Created by Nesteforenko on 8/21/17.
//  Copyright © 2017 Nixsolutions. All rights reserved.
//

import UIKit

class NetworkActivityIndicator {

  private static let sharedInstance = NetworkActivityIndicator()

  class func shared() -> NetworkActivityIndicator {
    return sharedInstance
  }

  private let syncQueue = DispatchQueue(label: "NetworkActivityIndicatorManager.syncQueue")

  private(set) var activeCount: Int {
    didSet {
      DispatchQueue.main.async { [weak self] in
        guard let strongSelf = self else { return }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = strongSelf.activeCount > 0
        if strongSelf.activeCount < 0 {
          strongSelf.activeCount = 0
        }
      }
    }
  }

  private init() {
    self.activeCount = 0
  }

  public func start() {
    syncQueue.sync { [unowned self] in
      self.activeCount += 1
    }
  }

  func end() {
    syncQueue.sync { [unowned self] in
      self.activeCount -= 1
    }
  }

  func endAll() {
    syncQueue.sync { [unowned self] in
      self.activeCount = 0
    }
  }
}
