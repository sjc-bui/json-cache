//
//  Devices+Extension.swift
//  json-cache
//
//  Created by quan bui on 2021/06/30.
//

import UIKit

struct ScreenSize
{
  static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
  static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
  static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
  static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

class Device {

  static let shared = Device()

  func keyboardSize() -> CGFloat {
    switch UIDevice.current.userInterfaceIdiom {
      case .pad:
        return ScreenSize.SCREEN_MIN_LENGTH / 2
      default:
        return ScreenSize.SCREEN_MIN_LENGTH
    }
  }
}
