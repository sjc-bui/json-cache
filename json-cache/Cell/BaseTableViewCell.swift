//
//  BaseTableViewCell.swift
//  json-cache
//
//  Created by quan bui on 2021/06/28.
//

import UIKit

open class BaseTableViewCell: UITableViewCell, Reusable {
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupDefault()
    initialize()
  }
  
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupDefault()
    initialize()
  }
  
  open override func awakeFromNib() {
    super.awakeFromNib()
    setupDefault()
    initialize()
  }
  
  func initialize() {}

  func setupDefault() {
    selectionStyle = .none
    backgroundColor = .white
  }
}
