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
        return Coin.blockchain(self).image.absoluteString
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
}
