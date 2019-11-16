//
//  BinanceModel.swift
//  AliceX
//
//  Created by lmcmz on 14/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import HandyJSON

struct BinanceNodeInfo: HandyJSON {
    var id: String!
    var network: String!
}

struct BinanceResult: HandyJSON {
    var hash: String!
    var code: Int!
    var log: String!
    var ok: Bool!
}

struct BinanceAccount: HandyJSON {
    
    var address: String!
    var sequence: Int64!
    var flag: Int!
    var account_number: Int64!
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
