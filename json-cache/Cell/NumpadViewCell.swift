//
//  NumpadViewCell.swift
//  json-cache
//
//  Created by quan bui on 2021/06/30.
//

import UIKit

class NumpadViewCell: BaseCollectionViewCell {

  private var numButton: UIButton = {
    let button = UIButton()
    button.titleLabel?.textAlignment = .center
    button.setTitleColor(.gray, for: .normal)
    button.clipsToBounds = true
    button.layer.cornerRadius = 4
    return button
  }()

  var item: Item! {
    didSet {
      self.numButton.setTitle(item.title, for: .normal)
      self.numButton.setTitleColor(item.titleColor, for: .normal)
      self.numButton.titleLabel?.font = item.font
      self.numButton.setImage(item.image, for: .normal)
      self.numButton.layer.cornerRadius = item.cornerRadius
      var image = item.backgroundColor.map { UIImage(color: $0) }
      numButton.setBackgroundImage(image, for: .normal)
      image = item.selectedBackgroundColor.map { UIImage(color: $0) }
      numButton.setBackgroundImage(image, for: .highlighted)
      numButton.setBackgroundImage(image, for: .selected)
    }
  }

  override func initialize() {
    super.initialize()
    layoutButton()
  }

  func layoutButton() {
    addSubview(numButton)
    numButton.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    numButton.addTarget(self, action: #selector(tap(_:)), for: .touchUpInside)
  }

  var buttonTapped: ((UIButton) -> Void)?

  @objc func tap(_ sender: UIButton) {
    buttonTapped?(sender)
  }
}
