//
//  ComponentFactory.swift
//  TestProj
//
//  Created by Aleksandr on 09.10.2018.
//  Copyright © 2018 qqq. All rights reserved.
//

import Foundation

protocol MainComponentFactory {
  func makeMainInteractor() -> MainInteractorType
  func makeMainAdapter() -> MainAdapterType
}

final class DefaultComponentFactory {
  fileprivate let serviceFactory: ServiceFactoryType
  
  init(serviceFactory: ServiceFactoryType) {
    self.serviceFactory = serviceFactory
  }
}

extension DefaultComponentFactory: MainComponentFactory {
  func makeMainInteractor() -> MainInteractorType {
    return MainInteractor(gateway: serviceFactory.makeAPIGateway(),
                          route: apiRouteGetGitRepos)
  }
  
  func makeMainAdapter() -> MainAdapterType {
    return MainAdapter()
  }
}
