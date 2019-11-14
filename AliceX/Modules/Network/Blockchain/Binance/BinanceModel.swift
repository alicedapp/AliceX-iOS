//
//  BinanceModel.swift
//  AliceX
//
//  Created by lmcmz on 14/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import HandyJSON

struct BinanceAccount: HandyJSON {
    
    var address: String!
    var sequence: Int!
    var flag: Int!
    var account_number: Int!
    var public_key: [Int]!
    var balances: [BinanceBalance]!
    
    init() {
    }
}

struct BinanceBalance: HandyJSON {
    var free: String!
    var frozen: String!
    var locked: String!
    var symbol: String!
    
    init() {
    }
}
