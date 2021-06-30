//
//  UITextField+Extension.swift
//  json-cache
//
//  Created by quan bui on 2021/06/30.
//

import UIKit

enum PaddingSpace {
  case left(CGFloat)
  case right(CGFloat)
  case equalSpacing(CGFloat)
}

extension UITextField {
  func add(padding: PaddingSpace) {
    self.layer.masksToBounds = true
    switch padding {
    case .left(let space):
      self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: space, height: self.frame.height))
      self.leftViewMode = .always
    case .right(let space):
      self.rightView = UIView(frame: CGRect(x: 0, y: 0, width: space, height: self.frame.height))
      self.rightViewMode = .always
    case .equalSpacing(let space):
      self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: space, height: self.frame.height))
      self.leftViewMode = .always
      self.rightView = UIView(frame: CGRect(x: 0, y: 0, width: space, height: self.frame.height))
      self.rightViewMode = .always
    }
  }
}
