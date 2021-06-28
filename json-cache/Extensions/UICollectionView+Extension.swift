//
//  UICollectionView+Extension.swift
//  json-cache
//
//  Created by quan bui on 2021/06/28.
//

import UIKit

public protocol Reusable {
  static var reuseIdentifier: String { get }
  static var nib: UINib? { get }
}

public extension Reusable {
  static var reuseIdentifier: String {
    return String(describing: Self.self)
  }

  static var nib: UINib? {
    return UINib(nibName: reuseIdentifier, bundle: nil)
  }
}

extension UICollectionView {
  func registerReusableNibCell<T: UICollectionViewCell>(_: T.Type) where T: Reusable {
    register(T.nib, forCellWithReuseIdentifier: T.reuseIdentifier)
  }

  func registerReusableCell<T: UICollectionViewCell>(_: T.Type) where T: Reusable {
    register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
  }

  func registerReusableSupplementaryView<T: UICollectionReusableView>(_ T: T.Type, forSupplementaryViewOfKind kind: String) where T: Reusable {
    register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.reuseIdentifier)
  }

  func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T where T: Reusable {
    guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
      return T()
    }
    return cell
  }

  func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind: String, for indexPath: IndexPath) -> T where T: Reusable {
    guard let cell = dequeueReusableSupplementaryView(ofKind: ofKind, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
      return T()
    }
    return cell
  }
}
