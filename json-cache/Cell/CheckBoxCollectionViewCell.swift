//
//  CheckBoxCollectionViewCell.swift
//  json-cache
//
//  Created by quan bui on 2021/06/29.
//

import UIKit

class CheckBoxCollectionViewCell: BaseCollectionViewCell {

  fileprivate lazy var container: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 6
    return view
  }()

  private let checkIcon: UIImageView = {
    let image = UIImageView()
    image.image = UIImage(named: "icon-checkbox-uncheck")
    image.contentMode = .scaleAspectFit
    return image
  }()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 18)
    label.textColor = .gray
    label.text = "Options"
    return label
  }()

  func configureData(with title: String, _ isSelected: Bool) {
      self.titleLabel.text = title
      if isSelected {
          self.checkIcon.image = UIImage(named: "icon-checkbox")
      } else {
          self.checkIcon.image = UIImage(named: "icon-checkbox-uncheck")
      }
  }

  override func initialize() {
    super.initialize()
    layoutContainer()
    layoutIcon()
    layoutTitle()
  }

  func layoutContainer() {
    addSubview(container)
    container.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  func layoutIcon() {
    container.addSubview(checkIcon)
    checkIcon.snp.makeConstraints { make in
      make.width.height.equalTo(25)
      make.left.equalToSuperview()
      make.centerY.equalToSuperview()
    }
  }

  func layoutTitle() {
    container.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.leading.equalTo(checkIcon.snp.trailing).offset(8)
      make.centerY.equalToSuperview()
    }
  }
}
