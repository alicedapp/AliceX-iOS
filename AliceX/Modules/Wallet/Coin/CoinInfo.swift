//
//  CoinInfo.swift
//  AliceX
//
//  Created by lmcmz on 6/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import HandyJSON
import PromiseKit
import BigInt
import web3swift

struct CoinInfo: HandyJSON {
    
    var id: String!  // ERC20 address, Blockchain Name
    var name: String!
    var symbol: String!
    var decimals: Int!
    var price: Double?
    var image: String!
    var changeIn24H: Double?
    
    var amount: String?
    
    var isPined: Bool = false
 
    init() {
    }
    
    init(id: String) {
        self.id = id
    }
    
    var coin: Coin {
        if id.count == 42 && id.hasPrefix("0x") {
            return Coin.ERC20(address: id)
        } else {
            return Coin.coin(chain: BlockChain(rawValue: id)! )
        }
    }
    
    var balance: Double {
        if let balance = amount, let balanceInt = BigUInt(balance),
           let amount = Web3.Utils.formatToPrecision(balanceInt, numberDecimals: decimals, formattingDecimals: 3, decimalSeparator: ".", fallbackToScientific: false),
         let price = price, let doubleAmount = Double(amount) {
            
            return doubleAmount * price
        }
        return 0
    }
}

extension CoinInfo: Hashable, Equatable {
    
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
