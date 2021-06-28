//
//  Cache.swift
//  json-cache
//
//  Created by quan bui on 2021/06/25.
//

import Foundation

final class Cache<Key: Hashable, Value> {

  private let cache = NSCache<WrappedKey, Entry>()
  private let lifeTime: TimeInterval
  private let dateProvider: () -> Date
  private let keyTracker = KeyTracker()

  init(dateProvider: @escaping () -> Date = Date.init,
       lifeTime: TimeInterval = 10,
       maxEntryCount: Int = 50) {
    self.dateProvider = dateProvider
    self.lifeTime     = lifeTime
    cache.countLimit  = maxEntryCount
    cache.delegate    = keyTracker
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
    let key: Key
    let value: Value
    let expirationDate: Date
    init(key: Key, value: Value, expirationDate: Date) {
      self.key = key
      self.value = value
      self.expirationDate = expirationDate
    }
  }
}

extension Cache {
  func insert(_ value: Value, forKey key: Key) {
    let date = dateProvider().addingTimeInterval(lifeTime)
    let entry = Entry(key: key, value: value, expirationDate: date)
    self.cache.setObject(entry, forKey: WrappedKey(key))
    self.keyTracker.keys.insert(key)
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

private extension Cache {
  final class KeyTracker: NSObject, NSCacheDelegate {
    var keys = Set<Key>()
    func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
      guard let entry = obj as? Entry else { return }
      keys.remove(entry.key)
    }
  }
}

private extension Cache {
  func entry(forKey key: Key) -> Entry? {
    guard let entry = cache.object(forKey: WrappedKey(key)) else { return nil }
    guard dateProvider() < entry.expirationDate else {
      remove(forKey: key)
      return nil
    }
    return entry
  }

  func insert(_ entry: Entry) {
    cache.setObject(entry, forKey: WrappedKey(entry.key))
    keyTracker.keys.insert(entry.key)
  }
}

extension Cache.Entry: Codable where Key: Codable, Value: Codable {}

extension Cache: Codable where Key: Codable, Value: Codable {
  convenience init(from decoder: Decoder) throws {
    self.init()
    let container = try decoder.singleValueContainer()
    let entries = try container.decode([Entry].self)
    entries.forEach(insert)
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(keyTracker.keys.compactMap(entry))
  }
}

extension Cache where Key: Codable, Value: Codable {
  func saveToDisk(withName name: String,
                  using fileManager: FileManager = .default) throws {
    let folderURLs = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
    let fileURL = folderURLs[0].appendingPathComponent("\(name).cache")
    let data = try JSONEncoder().encode(self)
    try data.write(to: fileURL)
  }
}
