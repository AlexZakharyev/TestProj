//
//  CommonProtocols.swift
//  TestProj
//
//  Created by zakhariev on 10/9/18.
//  Copyright © 2018 qqq. All rights reserved.
//

import UIKit

protocol Routable {
  func showViewController(_ viewController: UIViewController, fromViewController: UIViewController?, animated: Bool)
  func dismissViewController(_ viewController: UIViewController?)
}

extension Routable {
  func showViewController(_ viewController: UIViewController, fromViewController: UIViewController?, animated: Bool) {
    guard let fromViewController = fromViewController else { return }
    
    if fromViewController is UINavigationController,
      let navigationController = fromViewController as? UINavigationController {
      navigationController.isNavigationBarHidden = true
      
      if navigationController.viewControllers.isEmpty { navigationController.setViewControllers([viewController], animated: false) }
      else { navigationController.pushViewController(viewController, animated: animated) }
    }
    else {
      fromViewController.present(viewController, animated: animated, completion: nil)
    }
  }
  
  func dismissViewController(_ viewController: UIViewController?) {
    guard let viewController = viewController else { return }
    
    if viewController is UINavigationController,
      let navigationController = viewController as? UINavigationController {
      navigationController.popViewController(animated: true)
    } else {
      viewController.dismiss(animated: true, completion: nil)
    }
  }
}
