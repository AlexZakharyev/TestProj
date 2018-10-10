import Foundation
import PINCache

protocol APICacheStorageType {
  func set(object: JSONObject, forKey key: String)
  func object(for key: String) -> JSONObject?
}

protocol APICacheRemoverType {
  func removeAllObjects()
}

class APICacheStorage {
  fileprivate let cache: PINDiskCache
    
  init() {
     cache = PINDiskCache.shared()
     cache.ageLimit = TimeConstants.Week
  }
}

extension APICacheStorage: APICacheStorageType {
  func set(object: JSONObject, forKey key: String) {
    cache.setObject(object as NSCoding, forKey: key)
  }

  func object(for key: String) -> JSONObject? {
    guard let result = cache.object(forKey: key) else { return nil }
    return result as? JSONObject
  }
}

extension APICacheStorage: APICacheRemoverType {
  @objc func removeAllObjects() {
    cache.removeAllObjects()
  }
}
