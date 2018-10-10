//
//  ModuleFactory.swift
//  TestProj
//
//  Created by Aleksandr on 09.10.2018.
//  Copyright © 2018 qqq. All rights reserved.
//

import UIKit

protocol MainModuleFactory {
  func makeMainVC() -> ViewController
}

final class DefaultModuleFactory {
}

extension DefaultModuleFactory: MainModuleFactory {
  func makeMainVC() -> ViewController {
    return makeStoryboard(.main).initializeViewController()
  }
}




extension DefaultModuleFactory {
  fileprivate func makeStoryboard(_ name: StoryboardName) -> UIStoryboard {
    return UIStoryboard(name)
  }
}

protocol StoryboardIdentifiable {
  static var identifier: String { get }
}

extension UIViewController: StoryboardIdentifiable {}

extension StoryboardIdentifiable where Self: UIViewController {
  static var identifier: String {
    return String(describing: self)
  }
}

extension UIStoryboard {
  convenience init(_ storyboardName: StoryboardName) {
    self.init(name: storyboardName.rawValue, bundle: nil)
  }
  
  func initializeViewController<T>() -> T where T: StoryboardIdentifiable {
    guard let controller = instantiateViewController(withIdentifier: T.identifier) as? T else {
      fatalError("could not load view controller with identifier: \(T.identifier)")
    }
    return controller
  }
}

