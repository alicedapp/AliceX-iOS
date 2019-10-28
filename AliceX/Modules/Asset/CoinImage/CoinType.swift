//
//  CoinType.swift
//  AliceX
//
//  Created by lmcmz on 27/10/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import TrustWalletCore

enum Coin {
    case blockchain(BlockChain)
    case ERC20(String)
}

extension Coin {
    var image: URL {
        switch self {
        case .blockchain(let chain):
            return URL(string: "https://raw.githubusercontent.com/trustwallet/assets/master/blockchains/\(chain.rawValue.lowercased())/info/logo.png")!
        case .ERC20(let tokenAddress):
            return URL(string: "https://raw.githubusercontent.com/trustwallet/assets/master/blockchains/ethereum/assets/\(tokenAddress.lowercased())/logo.png")!
        }
    }
}
