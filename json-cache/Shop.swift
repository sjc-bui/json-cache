//
//  Shop.swift
//  json-cache
//
//  Created by quan bui on 2021/06/25.
//

struct Shop: Decodable {
  let shopCode: String
  let shopName: String
  let shopPhone: String
  let shopAddress: String
  let shopPostalCode: String

  enum CodingKeys: String, CodingKey {
    case shopCode       = "shop_code"
    case shopName       = "shop_name"
    case shopPhone      = "shop_phone"
    case shopAddress    = "shop_address"
    case shopPostalCode = "shop_postal_code"
  }
}
