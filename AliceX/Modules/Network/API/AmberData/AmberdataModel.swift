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

// MARK: - TX

struct AmberdataTXAddress: HandyJSON {
    var address: String!
    var icon: String?
    var nameNormalized: String?
}

struct AmberdataTXResult: HandyJSON {
    var code: String!
    var confirmed: Bool!
    var success: Bool!
    var name: String!
}

struct AmberdataTXTokenTransfers: HandyJSON {
    var amount: String!
    var decimals: String!
    var from: AmberdataTXAddress!
    var logIndex: Int!
    var name: String!
    var symbol: String!
    var timestamp: String!
    var to: AmberdataTXAddress!
    var tokenAddress: String!
}

struct AmberdataTXModel: HandyJSON {
    var blockNumber: String?
    var blockchainId: String?
    var confirmations: String?

    var contractAddress: String?
    var cumulativeGasUsed: String?
    var fee: String?

    var gasLimit: String?
    var gasPrice: String?
    var gasUsed: String!

    var hash: String!
    var index: Int64?
    var input: String?

    var timestamp: Date?
    var statusResult: AmberdataTXResult?

    var from: [AmberdataTXAddress]?
    var to: [AmberdataTXAddress]?

    var value: String?
    var tokenTransfers: [AmberdataTXTokenTransfers]?

    mutating func mapping(mapper: HelpingMapper) {
//        2019-07-26T08:06:29.000Z"
        mapper <<<
            timestamp <-- CustomDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
    }

    init() {}
}

extension AmberdataTXModel: Equatable, Hashable {
    static func == (lhs: AmberdataTXModel, rhs: AmberdataTXModel) -> Bool {
        return lhs.hash == rhs.hash
    }

    var hashValue: Int {
        return hash.hashValue
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(hash)
    }
}
