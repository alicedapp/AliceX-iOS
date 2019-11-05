//
//  Blockchain.swift
//  AliceX
//
//  Created by lmcmz on 28/10/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import TrustWalletCore

enum BlockChain: String, CaseIterable {
    case Ethereum
    case Bitcoin
    case Binance
    case Cosmos
    
//    case unknow
}

extension BlockChain {
    var coinMaeketCapID: Int {
        switch self {
        case .Ethereum:
            return 1027
        case .Binance:
            return 1839
        case .Bitcoin:
            return 1
        case .Cosmos:
            return 3794
        }
    }

    var data: CoinMarketCapDataModel? {
        return PriceHelper.shared.getChainData(chain: self)
    }
    
    var image: String {
        return Coin.coin(chain: self).image.absoluteString
    }

//    var price: Double {
//        PriceHelper.shared
//    }
    
    var coinType: CoinType {
        switch self {
        case .Ethereum:
            return .ethereum
        case .Binance:
            return .binance
        case .Bitcoin:
            return .bitcoin
        case .Cosmos:
            return .cosmos
        }
    }
    
    var sybmol: String {
        switch self {
        case .Ethereum:
            return "ETH"
        case .Binance:
            return "BNB"
        case .Bitcoin:
            return "BTC"
        case .Cosmos:
            return "ATOM"
        }
    }
    
    var amberDataID: String {
        switch self {
        case .Ethereum:
            return "1c9c969065fcd1cf"
        case .Bitcoin:
            return "408fa195a34b533de9ad9889f076045e"
        default:
            return "1c9c969065fcd1cf"
        }
    }
    
    var decimal: Int {
        switch self {
        case .Bitcoin, .Binance:
            return 8
        case .Ethereum:
            return 18
        case .Cosmos:
            return 9
        }
    }
}
