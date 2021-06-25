//
//  Cache.swift
//  json-cache
//
//  Created by quan bui on 2021/06/25.
//

import UIKit

final class Cache<Key: Hashable, Value> {

  private let cache = NSCache<WrappedKey, Entry>()
  private let lifeTime: TimeInterval
  private let dateProvider: () -> Date

  init(dateProvider: @escaping () -> Date = Date.init,
       lifeTime: TimeInterval = (12 * 60 * 60)) {
    self.dateProvider = dateProvider
    self.lifeTime     = lifeTime
  }

  final class WrappedKey: NSObject {
    let key: Key
    init(_ key: Key) {
      self.key = key
    }

    override var hash: Int {
      return self.key.hashValue
    }

    override func isEqual(_ object: Any?) -> Bool {
      guard let value = object as? WrappedKey else { return false }
      return value.key == key
    }
  }

  final class Entry {
    let value: Value
    let expirationDate: Date
    init(value: Value, expirationDate: Date) {
      self.value = value
      self.expirationDate = expirationDate
    }
  }
}

extension Cache {
  func insert(_ value: Value, forKey key: Key) {
    let date = dateProvider().addingTimeInterval(lifeTime)
    let entry = Entry(value: value, expirationDate: date)
    self.cache.setObject(entry, forKey: WrappedKey(key))
  }

  func value(forKey key: Key) -> Value? {
    guard let entry = self.cache.object(forKey: WrappedKey(key)) else { return nil }
    guard dateProvider() < entry.expirationDate else {
      remove(forKey: key)
      return nil
    }
    return entry.value
  }

  func remove(forKey key: Key) {
    self.cache.removeObject(forKey: WrappedKey(key))
  }
}
