//
//  CoinType.swift
//  AliceX
//
//  Created by lmcmz on 27/10/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import TrustWalletCore
import HandyJSON

struct CoinStruct: HandyJSON {
    
    var name: String!
    var symbol: String!
    var decimals: Int!
    var lastUpdated: Int!
    
    var address: String?
    var description: String?
    var website: String?
    var price: PriceInfo?
    var balance: Double!
}

enum Coin {
    case coin(chain: BlockChain)
    case ERC20(token: ERC20)
    
    var id: String {
        switch self {
        case .coin(let chain):
            return chain.rawValue
        case .ERC20(let token):
            return token.address
        }
    }
    
    var blockchain: BlockChain? {
        switch self {
        case .coin(let chain):
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
            return URL(string: "https://raw.githubusercontent.com/trustwallet/assets/master/blockchains/ethereum/assets/\(token.address.lowercased())/logo.png")!
        }
    }
    
    var name: String {
        switch self {
        case .coin(let chain):
            return chain.rawValue.firstUppercased
        case .ERC20(let token):
            return token.name
        }
    }
    
    var symbol: String {
        switch self {
        case .coin(let chain):
            return chain.sybmol
        case .ERC20(let token):
            return token.symbol
        }
    }
}

extension Coin: Hashable, Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }

    var hashValue: Int {
        return self.id.hashValue
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}
