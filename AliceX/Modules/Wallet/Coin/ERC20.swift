//
//  ERC20.swift
//  AliceX
//
//  Created by lmcmz on 2/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import HandyJSON

struct ERC20: HandyJSON {
    var address: String!
    var name: String!
    var symbol: String!
    var decimals: Int!
    var lastUpdated: Int!
    var description: String?
    var website: String?
    var price: PriceInfo?

    var balance: Double!

    init() {}

    init(address: String) {
        self.address = address
    }

    //    init(item: TokenArrayItem) {
    //        guard let info = item.tokenInfo else {
    //            return
    //        }
    //        self.balance = item.balance
    //        self.address = info.address
    //        self.name = info.name
    //        self.symbol = info.symbol
    //        self.decimals = info.decimals
    //        self.lastUpdated = info.lastUpdated
    //        self.website = info.website
    //        self.price = info.price
    //        self.description = info.description
    //    }
}

extension ERC20: Hashable, Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.address == rhs.address
    }

    var hashValue: Int {
        return address.hashValue
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(address)
    }
}
