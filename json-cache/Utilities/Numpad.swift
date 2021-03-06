//
//  Numpad.swift
//  json-cache
//
//  Created by quan bui on 2021/06/30.
//

import UIKit

public struct Item {

  var backgroundColor: UIColor? = UIColor(hex: "#FDFDFD")
  var selectedBackgroundColor: UIColor? = UIColor(hex: "#FDFDFD").withAlphaComponent(0.2)
  var image: UIImage?
  var title: String?
  var titleColor: UIColor? = .black
  var font: UIFont? = .systemFont(ofSize: 17)
  var cornerRadius: CGFloat = 4

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

extension NumpadDelegate {
  func numpad(_ numpad: Numpad, didSelectItem item: Item, atPosition position: Position) {}

  func numpad(_ numpad: Numpad, sizeForCellAtPosition position: Position) -> CGSize { return CGSize() }
}

open class Numpad: UIView {

  weak open var delegate: NumpadDelegate?

  weak open var dataSource: NumpadDataSource?

  private let spacing: CGFloat = 6

  private let defaultWidth = Device.shared.keyboardSize()

  fileprivate lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
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
      collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
      collectionView.widthAnchor.constraint(equalToConstant: defaultWidth),
      collectionView.centerXAnchor.constraint(equalTo: centerXAnchor)
    ])
  }

  open override var intrinsicContentSize: CGSize {
    return CGSize(width: UIView.noIntrinsicMetric, height: 0)
  }

  open override func layoutSubviews() {
    super.layoutSubviews()
  }

  open func invalidateLayout() {
      collectionView.collectionViewLayout.invalidateLayout()
  }

  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension Numpad: UICollectionViewDelegateFlowLayout {

  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: spacing, left: spacing, bottom: 0, right: spacing)
  }

  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return spacing
  }

  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return spacing
  }

  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let viewBoundWidth = collectionView.bounds.size.height

    let col = dataSource?.numpad(self, numberOfColumnsInRow: indexPath.section) ?? 0
    let row = self.numberOfRows()

    let totalSpaceH = CGFloat(col + 1) * spacing
    let totalSpaceV = CGFloat(row + 1) * spacing

    return CGSize(width: (defaultWidth - totalSpaceH) / CGFloat(col),
                  height: (viewBoundWidth - totalSpaceV - spacing) / CGFloat(row))
  }
}

extension Numpad: UICollectionViewDataSource {
  public func numberOfSections(in collectionView: UICollectionView) -> Int {
    return self.numberOfRows()
  }

  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.numberOfColumns(section: section)
  }

  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    var item = dataSource?.numpad(self, cellForItemAt: Position(row: indexPath.section, column: indexPath.item))
    let cell: NumpadViewCell = collectionView.dequeueReusableCell(for: indexPath)
    item?.cornerRadius = 20
    cell.item = item
    cell.buttonTapped = { [unowned self ] _ in
      self.delegate?.numpad(self, didSelectItem: item ?? Item(), atPosition: Position(row: indexPath.section, column: indexPath.item))
    }
    cell.backgroundColor = .clear
    return cell
  }
}

extension Numpad {
  func item(at position: Position) -> Item? {
    let indexPath = IndexPath(item: position.column, section: position.row)
    let item = collectionView.cellForItem(at: indexPath)
    return (item as? NumpadViewCell)?.item
  }

  func numberOfRows() -> Int {
    return dataSource?.numberOfRowsInNumpad(self) ?? 0
  }

  func numberOfColumns(section: Int) -> Int {
    return dataSource?.numpad(self, numberOfColumnsInRow: section) ?? 0
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
        item.backgroundColor = .clear
      case (3, 1):
        item.title = "0"
      case (3, 2):
        item.image = UIImage(named: "delete-back")
        item.backgroundColor = .clear
      default:
        var index = (0..<position.row)
          .map { self.numpad(self, numberOfColumnsInRow: $0) }
          .reduce(0, +)
        index += position.column
        item.title = "\(index + 1)"
    }
    item.font = UIFont.systemFont(ofSize: 28, weight: .regular)
    return item
  }
}
