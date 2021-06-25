//
//  EndPointType.swift
//  json-cache
//
//  Created by quan bui on 2021/06/25.
//

import UIKit

protocol EndPointType {
  var environmentBaseURL: String { get }
  var baseURL: URL { get }
  var path: String { get }
  var httpMethod: HttpMethod { get }
  var parameters: String { get }
}

extension EndPointType {
  var environmentBaseURL: String {
    return APIConfig.baseUrl
  }

  var baseURL: URL {
    let urlString = environmentBaseURL + path
    guard let url = URL(string: urlString) else {
      fatalError("baseURL could not be configured.")
    }
    return url
  }
}
