import Foundation

struct APIConfiguration {
  let scheme: String
  let host: String
}

enum APIError: Error, Equatable {
  case clientError(NSError)
  case parseMessageResponseError(message: String)
  case couldNotParseResponse
  case unknownError
  case notFound
  case unautorized
  case internetNotAvailable
  case conflict
  
  //Socket
  case connectionRefused
  case socketNotConnected
  
  //Product
  case productRemoved
}

func ==(lhs: APIError, rhs: APIError) -> Bool {
  switch (lhs, rhs) {
  case (.clientError(let lMsg), .clientError(let rMsg)):
    return lMsg == rMsg
  
  case (.parseMessageResponseError(let lMsg), .parseMessageResponseError(let rMsg)):
    return lMsg == rMsg
  
  case (.couldNotParseResponse, .couldNotParseResponse),
       (.unknownError, .unknownError),
       (.unautorized, .unautorized),
       (.internetNotAvailable, .internetNotAvailable),
       (.conflict, .conflict),
       (.connectionRefused, .connectionRefused),
       (.socketNotConnected, .socketNotConnected),
       (.productRemoved, .productRemoved),
       (.notFound, .notFound):
    return true
  
  default:
    return false
  }
}
