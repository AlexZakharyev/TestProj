
protocol HTTPClientType {
  func run(_ request: HTTPRequest, completion: @escaping (HTTPResult) -> Void) -> HTTPTask
}

protocol HTTPTask {
  func cancel()
}
