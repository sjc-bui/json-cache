//
//  APIError.swift
//  json-cache
//
//  Created by quan bui on 2021/06/25.
//

import UIKit

enum APIError: Error {
  case invalidData
  case jsonDecodingFailure
  case responseUnsuccessful(description: String)
  case decodingTaskFailure(description: String)
  case requestFailed(description: String)
  case jsonConversionFailure(description: String)
  case postParametersEncodingFalure(description: String)

  var customDescription: String {
    switch self {
    case .requestFailed(let description): return "APIError - Request Failed -> \(description)"
    case .invalidData: return "Invalid Data"
    case .responseUnsuccessful(let description): return "APIError - Response Unsuccessful status code -> \(description)"
    case .jsonDecodingFailure: return "APIError - JSON decoding Failure"
    case .jsonConversionFailure(let description): return "APIError - JSON Conversion Failure -> \(description)"
    case .decodingTaskFailure(let description): return "APIError - decodingtask failure with error -> \(description)"
    case .postParametersEncodingFalure(let description): return "APIError - post parameters failure -> \(description)"
    }
  }
}
