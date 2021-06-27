//
//  Shop.swift
//  json-cache
//
//  Created by quan bui on 2021/06/25.
//

import UIKit

class Shop: NSObject, Codable {

  var shopCode: String = ""
  var shopName: String = ""
  var shopPhone: String = ""
  var shopAddress: String = ""
  var shopPostalCode: String = ""

  enum CodingKeys: String, CodingKey {
    case shopCode       = "shop_code"
    case shopName       = "shop_name"
    case shopPhone      = "shop_phone"
    case shopAddress    = "shop_address"
    case shopPostalCode = "shop_postal_code"
  }
  
  required override init() {}

  required init(shopCode: String,
       shopName: String,
       shopPhone: String,
       shopAddress: String,
       shopPostalCode: String
  ) {
    super.init()
    self.shopCode = shopCode
    self.shopName = shopName
    self.shopPhone = shopPhone
    self.shopAddress = shopAddress
    self.shopPostalCode = shopPostalCode
  }
}
