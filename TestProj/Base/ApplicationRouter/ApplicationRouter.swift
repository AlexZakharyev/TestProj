//
//  ApplicationRouter.swift
//  TestProj
//
//  Created by Aleksandr on 09.10.2018.
//  Copyright © 2018 qqq. All rights reserved.
//

import UIKit

final class ApplicationRouter {
  private let applicationAssembly: ApplicationAssemblyProtocol
  private let assemblyRouter: ApplicationAssemblyRoutingProtocol
  private var currentRootWindow: UIWindow?
  private var navigationController: UINavigationController?
  
  init(applicationAssembly: ApplicationAssemblyProtocol,
       assemblyRouter: ApplicationAssemblyRoutingProtocol) {
    self.applicationAssembly = applicationAssembly
    self.assemblyRouter = assemblyRouter
  }
  
  func rootWindow() -> UIWindow {
    if currentRootWindow == nil {
      currentRootWindow = UIWindow(frame: UIScreen.main.bounds)
      navigationController = UINavigationController()
      
      let (_, mainRouter) = assemblyRouter.makeMainAssemblyRouter()
      mainRouter.showMainViewController(from: navigationController!, animated: true)
      currentRootWindow?.rootViewController = navigationController
    }
    
    return currentRootWindow!
  }
}
