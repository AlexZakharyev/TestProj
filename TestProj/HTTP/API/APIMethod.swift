struct APIMethod<ResultType> {
  let cacheKey: String
  let httpMethod: HTTPMethod
  let path: String
  let percentEncodedQuery: Query?
  let body: BodyObject?
  let resultParser: (JSONObject) -> ResultType?
  let headerFields: HeaderFields 
}
