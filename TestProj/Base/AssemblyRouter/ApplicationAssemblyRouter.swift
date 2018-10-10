//
//  ApplicationAssemblyRouter.swift
//  TestProj
//
//  Created by zakhariev on 10/9/18.
//  Copyright © 2018 qqq. All rights reserved.
//

import Foundation

protocol ApplicationAssemblyRoutingProtocol {
  // MARK: Main
  func makeMainAssemblyRouter() -> (MainAssemblyProtocol, MainRouterType)
}


final class ApplicationAssemblyRouter: ApplicationAssemblyRoutingProtocol {
  
  fileprivate let applicationAssemlbly: ApplicationAssemblyProtocol
  
  init(applicationAssemlbly: ApplicationAssemblyProtocol) {
    self.applicationAssemlbly = applicationAssemlbly
  }
  
  func makeMainAssemblyRouter() -> (MainAssemblyProtocol, MainRouterType) {
    let componentFactory = DefaultComponentFactory(serviceFactory: applicationAssemlbly.makeServiceFactory())
    let assembly = MainAssembly(moduleFactory: DefaultModuleFactory(),
                                componentFactory: componentFactory)
    let router = MainRouter(assembly: assembly, assemblyRouter: self)
    
    return (assembly, router)
}
}
