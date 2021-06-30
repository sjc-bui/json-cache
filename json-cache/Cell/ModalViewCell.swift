//
//  ModalViewCell.swift
//  json-cache
//
//  Created by quan bui on 2021/06/29.
//

import UIKit

class ModalViewCell: BaseTableViewCell {

  fileprivate lazy var checkImageView: UIImageView = {
    let image = UIImageView()
    image.contentMode = .scaleAspectFit
    image.image = UIImage(color: .white)
    return image
  }()

  private var title: UILabel = {
    let label = UILabel()
    label.textAlignment = .left
    label.font = UIFont.systemFont(ofSize: 17)
    label.numberOfLines = 1
    return label
  }()

  private var status: UILabel = {
    let label = UILabel()
    label.textAlignment = .right
    label.font = UIFont.systemFont(ofSize: 17)
    label.numberOfLines = 1
    return label
  }()

  func config(title: String, status: String) {
    self.title.text = title
    self.status.text = status
  }

  override var isSelected: Bool {
    didSet {
      if isSelected {
        checkImageView.image = ImageManager.checkMarkCheck
      } else {
        checkImageView.image = UIImage(color: .white)
      }
    }
  }

  override func initialize() {
    super.initialize()
    layoutImage()
    layoutTitle()
    layoutStatus()
  }

  func layoutImage() {
    addSubview(checkImageView)
    checkImageView.snp.makeConstraints { make in
      make.width.height.equalTo(20)
      make.left.equalToSuperview().offset(16)
      make.centerY.equalToSuperview()
    }
  }

  func layoutTitle() {
    addSubview(title)
    title.snp.makeConstraints { make in
      make.left.equalTo(checkImageView.snp.right).offset(8)
      make.centerY.equalToSuperview()
    }
  }

  func layoutStatus() {
    addSubview(status)
    status.snp.makeConstraints { make in
      make.left.equalTo(title.snp.right).offset(8)
      make.right.equalToSuperview().offset(-24)
      make.centerY.equalToSuperview()
    }
  }
}
