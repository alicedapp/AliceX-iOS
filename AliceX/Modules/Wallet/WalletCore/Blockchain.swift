//
//  Blockchain.swift
//  AliceX
//
//  Created by lmcmz on 28/10/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation

enum BlockChain: String, CaseIterable {
    case Ethereum
    case Bitcoin
    case Binance
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
        }
    }
    
    var data: CoinMarketCapDataModel? {
        return PriceHelper.shared.getChainData(chain: self)
    }
    
//    var price: Double {
//        PriceHelper.shared
//    }
    
    
}
