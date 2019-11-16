//
//  CoinType.swift
//  AliceX
//
//  Created by lmcmz on 27/10/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import PromiseKit
import TrustWalletCore
import web3swift

enum Coin {
    case coin(chain: BlockChain)
    case ERC20(address: String)

    var id: String {
        switch self {
        case let .coin(chain):
            return chain.rawValue
        case let .ERC20(token):
            return token
        }
    }

    var blockchain: BlockChain? {
        switch self {
        case let .coin(chain):
            return chain
        default:
            return nil
        }
    }

    var isERC20: Bool {
        switch self {
        case .coin:
            return false
        case .ERC20:
            return true
        }
    }

    var image: URL {
        switch self {
        case let .coin(chain):
            return URL(string: "https://raw.githubusercontent.com/trustwallet/assets/master/blockchains/\(chain.rawValue.lowercased())/info/logo.png")!
        case let .ERC20(token):
            return URL(string: "https://raw.githubusercontent.com/trustwallet/assets/master/blockchains/ethereum/assets/\(EthereumAddress.toChecksumAddress(token)!)/logo.png")!
        }
    }

    var type: String {
        switch self {
        case .coin:
            return "Coin"
        case .ERC20:
            return "ERC20"
        }
    }

//    var name: String {
//        switch self {
//        case .coin(let chain):
//            return chain.rawValue.firstUppercased
//        case .ERC20(let token):
//            return token.name
//        }
//    }
//
//    var symbol: String {
//        switch self {
//        case .coin(let chain):
//            return chain.symbol
//        case .ERC20(let token):
//            return CoinInfoCenter.shared.
//        }
//    }

    var info: CoinInfo? {
        if CoinInfoCenter.shared.pool.keys.contains(id) {
            return CoinInfoCenter.shared.pool[id]!
        }

        return nil
    }

//    func info() -> CoinInfo {
//        firstly {
//
//        }.done { info in
    ////            self.info = info
//            return info
//        }
//
//    }

    func verify(address: String) -> Bool {
        switch self {
        case let .coin(chain):
            return chain.verify(address: address)
        case .ERC20:
            return BlockChain.Ethereum.verify(address: address)
        }
    }
}

extension Coin: Hashable, Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }

    var hashValue: Int {
        return id.hashValue
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
