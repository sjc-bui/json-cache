//
//  ItemCollectionViewCell.swift
//  json-cache
//
//  Created by quan bui on 2021/06/27.
//

import UIKit

class ItemCollectionViewCell: BaseCollectionViewCell {

  fileprivate lazy var coverView: UIView = {
    let view = UIView(frame: .zero)
    return view
  }()

  fileprivate lazy var title: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.textAlignment = .center
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 22)
    return label
  }()

  override func initialize() {
    super.initialize()
    layoutCoverView()
    layoutTitle()
  }

  func config(_ title: String) {
    self.title.text = title
  }

  func layoutCoverView() {
    addSubview(coverView)
    coverView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  func layoutTitle() {
    coverView.addSubview(title)
    title.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview()
    }
  }
}
