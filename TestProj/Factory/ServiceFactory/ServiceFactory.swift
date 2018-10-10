//
//  ServiceFactory.swift
//  TestProj
//
//  Created by Aleksandr on 09.10.2018.
//  Copyright © 2018 qqq. All rights reserved.
//

import Foundation

protocol ServiceFactoryType {
  func makeAPIGateway<T>() -> APIGateway<T>
}

final class ServiceFactory: ServiceFactoryType {
  
  // MARK: API
  func makeAPIGateway<T>() -> APIGateway<T> {
    return APIGateway(client: makeApiClient(),
                      methodBuilder: makeAPIMethodBuilder())
  }

  fileprivate func makeApiClient<T>() -> AnyAPIClient<T> {
    let configuration = makeApiPreferences().apiConfiguration()
    let apiClient = APIClient<T>(httpClient: makeHTTPClient(),
                                 configuration: configuration,
                                 cache: APICacheStorage())
    
    return AnyAPIClient(apiClient)
  }
  
  fileprivate func makeAPIMethodBuilder<T>() -> APIMethodBuilder<T> {
    let pathBuilder = DefaultAPIPathBuilder()
    let builder = DefaultAPIParametersBuilder()
    let bodyBuilder = DefaultAPIBodyBuilder()
    
    return APIMethodBuilder(pathBuilder: pathBuilder,
                            paramsBuilder: builder,
                            bodyBuilder: bodyBuilder,
                            requestHeaderBuilder: makeAPIRequestHeaderBuilder(),
                            cacheKeyBuilder: DefaultAPICacheKeyBuilder(pathBuilder: pathBuilder, builder: builder))
  }
  
  func makeAPIRequestHeaderBuilder() -> APIRequestHeaderBuilderType {
    return APIRequestHeaderBuilder.sharedInstance
  }
  
  fileprivate func makeHTTPClient() -> HTTPClientType {
    let httpClient = NSURLSessionBasedHTTPClient.sharedInstance
    return httpClient
  }
  
  func makeApiPreferences() -> APIPreferences {
    return APIPreferences()
  }
}
