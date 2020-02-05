//
//  AmberdataModel.swift
//  AliceX
//
//  Created by lmcmz on 5/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import HandyJSON

struct AmberdataTokenPrice: HandyJSON {
    var address: String!
    var symbol: String!
    var name: String!
}

struct AmberdataBalance: HandyJSON {
    var value: String!
}

struct AmberdataTokenList: HandyJSON {
    var records: [AmberdataToken]!
    var totalRecords: Int!
}

struct AmberdataToken: HandyJSON {
    var address: String!
    var holder: String!
    var amount: String!
    var decimals: Int!
    var name: String!
    var symbol: String!
    var isERC20: Bool!
    var isERC777: Bool!
    var isERC721: Bool!
    var isERC884: Bool!
    var isERC998: Bool!
}

struct AmberdataAddress: HandyJSON {
    var address: String!
}

struct AmberdataTXRecord: HandyJSON {
    var transactionHash: String!
    var blockHash: String!
    var blockNumber: String!
    var tokenAddress: String!
    var amount: String!
    var timestamp: Int64!
    var timestampNanoseconds: Int!
    var logIndex: Int!
    var blockchainId: String!
    var to: AmberdataAddress!
    var from: AmberdataAddress!
    var decimals: Int!
    var name: String!
    var symbol: String!
    var isERC20: Bool!
    var isERC777: Bool!
    var isERC721: Bool!
    var isERC884: Bool!
    var isERC998: Bool!
}

struct AmberdataPricePoint: HandyJSON {
    var timestamp: TimeInterval?
    var price: Double?

    public mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            timestamp <-- TransformOf<TimeInterval, Double>(fromJSON: { rawString -> TimeInterval? in

                guard let double = rawString else {
                    return nil
                }

                let time = double / 1000
                let timestamp = TimeInterval(time)
                return timestamp
            }, toJSON: { value -> Double? in
                Double(value!)
            })

        mapper <<<
            price <-- TransformOf<Double, String>(fromJSON: { rawString -> Double? in

                guard let price = Double(rawString!) else {
                    return nil
                }

                return price

            }, toJSON: { value -> String in
                String(value!)
            })
    }
}
