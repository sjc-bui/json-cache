//
//  ShopEndPoint.swift
//  json-cache
//
//  Created by quan bui on 2021/06/25.
//

import UIKit

enum ShopEndPoint {
  case list
}

extension ShopEndPoint: EndPointType {

  var httpMethod: HttpMethod {
    switch self {
    case .list:
      return .get
    }
  }

  var path: String {
    switch self {
    case .list:
      return "/shops/list"
    }
  }

  var parameters: String {
    return ""
  }
}
