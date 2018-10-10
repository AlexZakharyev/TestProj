//
//  ApplicationAssembly.swift
//  TestProj
//
//  Created by Aleksandr on 09.10.2018.
//  Copyright © 2018 qqq. All rights reserved.
//

import Foundation

protocol ApplicationAssemblyProtocol: class {
  func makeServiceFactory() -> ServiceFactoryType
}

class ApplicationAssembly: ApplicationAssemblyProtocol {
  
  func makeServiceFactory() -> ServiceFactoryType {
    return ServiceFactory()
  }
}
