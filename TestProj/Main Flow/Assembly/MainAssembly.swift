//
//  MainAssembly.swift
//  TestProj
//
//  Created by Aleksandr on 09.10.2018.
//  Copyright © 2018 qqq. All rights reserved.
//

import Foundation

protocol MainAssemblyProtocol {
  func assemblyMainViewController() -> ViewController
}

final class MainAssembly: MainAssemblyProtocol {
  fileprivate let moduleFactory: MainModuleFactory
  fileprivate let componentFactory: MainComponentFactory
  
  init(moduleFactory: MainModuleFactory, componentFactory: MainComponentFactory) {
    self.moduleFactory = moduleFactory
    self.componentFactory = componentFactory
  }
  
  func assemblyMainViewController() -> ViewController {
    let controller = moduleFactory.makeMainVC()
    controller.interactor = componentFactory.makeMainInteractor()
    controller.adapter = componentFactory.makeMainAdapter()
    return controller
  }
}
