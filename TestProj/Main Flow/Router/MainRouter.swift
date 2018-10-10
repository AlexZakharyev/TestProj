//
//  MainRouter.swift
//  TestProj
//
//  Created by Aleksandr on 09.10.2018.
//  Copyright © 2018 qqq. All rights reserved.
//

import UIKit

protocol MainRouterType {
  func showMainViewController(from viewController: UIViewController, animated: Bool)
}

final class MainRouter: Routable, MainRouterType {
  private let assembly: MainAssemblyProtocol
  private let assemblyRouter: ApplicationAssemblyRoutingProtocol
  
  init(assembly: MainAssemblyProtocol, assemblyRouter: ApplicationAssemblyRoutingProtocol) {
    self.assembly = assembly
    self.assemblyRouter = assemblyRouter
  }
  
  func showMainViewController(from viewController: UIViewController, animated: Bool) {
    let controller = assembly.assemblyMainViewController()
    showViewController(controller, fromViewController: viewController, animated: animated)
    
  }
}
