//
//  CryptocompareModel.swift
//  AliceX
//
//  Created by lmcmz on 4/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import HandyJSON

struct CryptocompareModel: HandyJSON {
    var MARKET: String!
    var FROMSYMBOL: String!
    var TOSYMBOL: String!
    var PRICE: Double!
    var CHANGE24HOUR: Double!
}
