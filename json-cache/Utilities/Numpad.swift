//
//  Numpad.swift
//  json-cache
//
//  Created by quan bui on 2021/06/30.
//

import UIKit

public struct Item {
  public var backgroundColor: UIColor? = .white
  public var selectedBackgroundColor: UIColor? = .lightGray.withAlphaComponent(0.3)
  public var image: UIImage?
  public var title: String?
  public var titleColor: UIColor? = .black
  public var font: UIFont? = .systemFont(ofSize: 17)
  public var tag: Int = 0

  public init() {}

  public init(title: String?) {
    self.title = title
  }

  public init(image: UIImage?) {
    self.image = image
  }
}

public typealias Position = (row: Int, column: Int)

public protocol NumpadDataSource: AnyObject {

  func numberOfRowsInNumpad(_ numpad: Numpad) -> Int

  func numpad(_ numpad: Numpad, numberOfColumnsInRow row: Int) -> Int

  func numpad(_ numpad: Numpad, cellForItemAt position: Position) -> Item
}

public protocol NumpadDelegate: AnyObject {

  func numpad(_ numpad: Numpad, didSelectItem item: Item, atPosition position: Position)

  func numpad(_ numpad: Numpad, sizeForCellAtPosition position: Position) -> CGSize
}

open class Numpad: UIView {

  weak open var delegate: NumpadDelegate?

  weak open var dataSource: NumpadDataSource?

  fileprivate lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.allowsSelection = false
    collectionView.isScrollEnabled = false
    collectionView.backgroundColor = .clear
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.registerReusableCell(NumpadViewCell.self)
    return collectionView
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(collectionView)
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }

  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension Numpad: UICollectionViewDelegateFlowLayout {
  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let position = Position(row: indexPath.section, column: indexPath.item)
    let size = delegate?.numpad(self, sizeForCellAtPosition: position) ?? CGSize()
    //return !size.equalTo(CGSize()) ? size : .zero
    let width = collectionView.bounds.size.width
    let col = dataSource?.numpad(self, numberOfColumnsInRow: indexPath.section)
    return CGSize(width: width / CGFloat(col ?? 0),
                  height: 50)
  }
}

extension Numpad: UICollectionViewDelegate {
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    print("do something.")
  }
}

extension Numpad: UICollectionViewDataSource {
  public func numberOfSections(in collectionView: UICollectionView) -> Int {
    return dataSource?.numberOfRowsInNumpad(self) ?? 0
  }

  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return dataSource?.numpad(self, numberOfColumnsInRow: section) ?? 0
  }

  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let item = dataSource?.numpad(self, cellForItemAt: Position(row: indexPath.section, column: indexPath.item))
    let cell: NumpadViewCell = collectionView.dequeueReusableCell(for: indexPath)
    cell.item = item
    cell.delegate = self
    return cell
  }
}

extension Numpad: NumpadViewCellDelegate {
  func didTapNumber(tag: Int) {
    print("Did tap at number \(tag)")
  }
}

open class DefaulNumpad: Numpad {
  override init(frame: CGRect) {
    super.init(frame: frame)
    initialize()
  }

  required public init?(coder: NSCoder) {
    super.init(coder: coder)
    initialize()
  }

  func initialize() {
    dataSource = self
  }
}

extension DefaulNumpad: NumpadDataSource {

  public func numberOfRowsInNumpad(_ numpad: Numpad) -> Int {
    return 4
  }

  public func numpad(_ numpad: Numpad, numberOfColumnsInRow row: Int) -> Int {
    return 3
  }

  public func numpad(_ numpad: Numpad, cellForItemAt position: Position) -> Item {
    var item = Item()
    switch position {
      case (3, 0):
        item.title = "C"
        item.tag = 100
      case (3, 1):
        item.title = "0"
        item.tag = 0
      case (3, 2):
        item.title = "←"
        item.tag = 101
      default:
        var index = (0..<position.row)
          .map { self.numpad(self, numberOfColumnsInRow: $0) }
          .reduce(0, +)
        index += position.column
        item.title = "\(index + 1)"
        item.tag = index + 1
    }
    item.titleColor = .orange
    item.font = UIFont.systemFont(ofSize: 30)
    return item
  }
}
