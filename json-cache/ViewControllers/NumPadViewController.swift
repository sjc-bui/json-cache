//
//  NumPadViewController.swift
//  json-cache
//
//  Created by quan bui on 2021/06/30.
//

import UIKit

class NumPadViewController: BaseViewController {

  lazy var numpad: Numpad = {
    let pad = DefaulNumpad()
    return pad
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    layoutNumpad()
  }
  
  func layoutNumpad() {
    self.view.addSubview(numpad)
    numpad.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
}
