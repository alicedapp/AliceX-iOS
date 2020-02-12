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

struct BinanceErrorResult: HandyJSON {
    var code: Int!
    var message: String!
    var failed_tx_index: Int!
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

    init() {}
}

struct BinanceBalance: HandyJSON {
    var free: String!
    var frozen: String!
    var locked: String!
    var symbol: String!

    init() {}
}


struct BinanceTXModel: HandyJSON {
    
    var txHash: String!
    var blockHeight: NSNumber!
    var timeStamp: String! //"2019-12-09T11:09:38.151Z",
    var fromAddr: String!
    var toAddr: String!
    
    var value: String!
    var txAsset: String!
    var txFee: Double!
    var txAge: NSNumber!
    var code: NSNumber!
    var sequence: NSNumber!
    var memo: String!

    init() {}
    
    func convertToAmberdata() -> AmberdataTXModel {
        var model = AmberdataTXModel()
        var from = AmberdataTXAddress()
        from.address = fromAddr
        model.from = [from]
        var to = AmberdataTXAddress()
        to.address = toAddr
        model.to = [to]
        model.timestamp = timeStamp.toDate(format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
        model.value = String(Int64(Double(value)! * pow(10, BlockChain.Binance.decimal).doubleValue))
        model.hash = txHash
        return model
    }
}
