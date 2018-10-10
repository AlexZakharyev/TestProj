//
//  JSON.swift
//  BLOK
//
//  Created by Aleksandr Zakhariev on 8/28/17.
//  Copyright © 2017 Nixsolutions. All rights reserved.
//

import Foundation

typealias Query = String
typealias JSON = Any
typealias JSONObject = [String: Any]
typealias JSONArray = [Any]

typealias JSONArrayOfJSONObjects = [JSONObject]


/// See: NSJSONSerialization.dataWithJSONObject(_:options:)
let systemJSONEncoding = String.Encoding.utf8


protocol JSONDecodable {
  init?(json: JSON)
}

protocol JSONObjectDecodable {
  /// Should be used only with wrapper's, not in pure swift classes.
  /// Otherwise default implementation will return empty `JSONObject`
  var rawData: JSONObject { get }
  init?(jsonObject: JSONObject)
}

extension JSONObjectDecodable {
  var rawData: JSONObject {
    return [:]
  }
}

protocol JSONObjectEncodable {
  func encode() -> JSONObject
}

enum JSONDecodeOptions { }

func decodeJSON(data: Data, options: [JSONDecodeOptions] = []) throws -> JSON {
  return try JSONSerialization.jsonObject(with: data, options: .allowFragments)
}

enum JSONEncodeOptions { }

func encodeJSON(_ json: JSON, options: [JSONEncodeOptions] = []) throws -> Data {
  return try JSONSerialization.data(withJSONObject: json, options: [])
}

func += <KeyType, ValueType> (left: inout Dictionary<KeyType, ValueType>, right: Dictionary<KeyType, ValueType>) {
  for (key, value) in right {
    left.updateValue(value, forKey: key)
  }
}

func + <K,V>(left: Dictionary<K,V>, right: Dictionary<K,V>) -> Dictionary<K,V> {
  var map = Dictionary<K,V>()
  map += left
  map += right
  return map
}


func ==(lhs: JSONObject, rhs: JSONObject) -> Bool {
  return NSDictionary(dictionary: lhs).isEqual(to: rhs)
}

func ==<T: Equatable>(lhs: [T]?, rhs: [T]?) -> Bool {
  switch (lhs, rhs) {
  case let (left?, right?) : // shortcut for (.Some(l), .Some(r))
    return left == right
  case (.none, .none):
    return true
  default:
    return false
  }
}

func !=(lhs: JSONObject, rhs: JSONObject) -> Bool {
  return !(lhs == rhs)
}



@dynamicMemberLookup
public protocol DynamicNested {}

public extension DynamicNested {
  subscript(dynamicMember member: String) -> Self? {
    return nil
  }
}

extension Dictionary: DynamicNested where Dictionary.Key == String,
Dictionary.Value == Any {
  subscript(dynamicMember member: String) -> JSONObject? {
    return self[member] as? JSONObject
  }
  
  public subscript<Type>(dynamicMember member: String) -> Type? {
    print(Type.self)
    return self[member] as? Type
  }
}
