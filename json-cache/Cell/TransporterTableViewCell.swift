//
//  TransporterTableViewCell.swift
//  json-cache
//
//  Created by quan bui on 2021/06/28.
//

import UIKit

class ImageManager {
  static let checkMarkCheck   = UIImage(named: "checkMarkCheck")
  static let checkMarkUnCheck = UIImage(named: "checkMarkUnCheck")
  static let logoGHTK        = UIImage(named: "logoGHTK")
  static let logoVietNamPost = UIImage(named: "logoVietNamPost")
}

class TransporterTableViewCell: UITableViewCell {

  fileprivate lazy var checkImageView: UIImageView = {
    let image = UIImageView()
    image.image = ImageManager.checkMarkUnCheck
    image.contentMode = .scaleAspectFit
    return image
  }()
  
  fileprivate lazy var logoImageView: UIImageView = {
    let image = UIImageView()
    image.image = ImageManager.logoGHTK
    image.contentMode = .scaleAspectFit
    return image
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    initialize()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override var isSelected: Bool {
    didSet {
      if isSelected {
        checkImageView.image = ImageManager.checkMarkCheck
      } else {
        checkImageView.image = ImageManager.checkMarkUnCheck
      }
    }
  }
  
  func configCell(type: TransportType) {
    logoImageView.image = type.logo
  }
  
  func initialize() {
    layoutCheckImage()
    layoutLogoImage()
  }

  func layoutCheckImage() {
    addSubview(checkImageView)
    checkImageView.snp.makeConstraints { make in
      make.width.height.equalTo(18)
      make.left.equalToSuperview().offset(10)
      make.centerY.equalToSuperview()
    }
  }

  func layoutLogoImage() {
    addSubview(logoImageView)
    logoImageView.snp.makeConstraints { make in
      make.width.equalTo(200)
      make.height.equalTo(50)
      make.centerY.equalToSuperview()
      make.left.equalTo(checkImageView.snp.right).offset(16)
    }
  }
}
