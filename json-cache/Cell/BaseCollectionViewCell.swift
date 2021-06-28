//
//  BaseCollectionViewCell.swift
//  json-cache
//
//  Created by quan bui on 2021/06/28.
//

import UIKit

open class BaseCollectionViewCell: UICollectionViewCell, Reusable {

  public override init(frame: CGRect) {
    super.init(frame: frame)
    setupDefaults()
    initialize()
  }

  required public init?(coder: NSCoder) {
    super.init(coder: coder)
    setupDefaults()
    initialize()
  }
  
  open override func awakeFromNib() {
    super.awakeFromNib()
    setupDefaults()
    initialize()
  }

  func initialize() { }

  func setupDefaults() {
    backgroundColor = .white
  }
}
