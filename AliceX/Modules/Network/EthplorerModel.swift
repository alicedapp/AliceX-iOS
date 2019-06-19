//
//  AddressInfo.swift
//  AliceX
//
//  Created by lmcmz on 19/6/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import HandyJSON
import BigInt

// MARK: - Token
struct TokenInfo: HandyJSON {
    var address: String!
    var totalSupply: String!
    var name: String!
    var symbol: String!
    var decimals: Int!
    var owner: String!
    var countOps: Int!
    var totalIn: Int!
    var totalOut: Int!
    var transfersCount: Int!
    var holdersCount: Int!
    var issuancesCount: Int!
    var lastUpdated: Int!
    var description: String?
    var website: String?
    var ethTransfersCount: Int?
    var pricre: PriceInfo?
    var image: String?
    
    init() {
    }
}

// MARK: - Address

struct ETHBalance: HandyJSON {
    var balance: Double!
}

struct PriceInfo: HandyJSON {
    var rate: Double!
    var currency: String!
    var diff: Double!
    var diff7d: Double!
    var diff30d: Double!
    var marketCapUsd: String!
    var availableSupply: String!
    var volume24h: String!
    var ts: Int!
}

struct TokenArrayItem: HandyJSON {
    var tokenInfo: TokenInfo!
    var balance: String!
    var totalIn: Int!
    var totalOut: Int!
    
    init() {
    }
}

struct ContractInfo: HandyJSON {
    var creatorAddress: String!
    var transactionHash: String!
    var timestamp: String!
}

struct AddressInfo: HandyJSON {
    var address: String!
    var ETH: ETHBalance!
    var contractInfo: ContractInfo?
    var countTxs: String!
    var tokens: [TokenArrayItem]!
    var tokenInfo: TokenInfo?
    
    init() {
    }
}

// MARK: - Tx

struct TXInfo {
    
}
