enum Result<T: Equatable, E: Equatable>: Equatable {
  case success(T)
  case failure(E)
}

func ==<T, E>(lhs: Result<T, E>, rhs: Result<T, E>) -> Bool where T: Equatable, E: Equatable {
  switch (lhs, rhs) {
  case let (.success(lhs), .success(rhs)):
    let result = lhs == rhs
    return result
  case let (.failure(lhs), .failure(rhs)):
    return lhs == rhs
  default:
    return false
  }
}
