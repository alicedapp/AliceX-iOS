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
    
    var OPEN24HOUR: Double!
    var HIGH24HOUR: Double!
    var LOW24HOUR: Double!
    var VOLUME24HOUR: Double!
    var LASTUPDATE: TimeInterval!
    
    var SUPPLY: Int64!
    var MKTCAP: NSNumber!
}


struct CryptocompareHistoryData: HandyJSON {
    var time: TimeInterval!
    var high: Double!
    var low: Double!
    var open: Double!
    var close: Double!
    var volumefrom: Double!
    var volumeto: Double!
    
    var conversionType: String?
    var conversionSymbol: String?
}

struct CryptocompareHistoryModel: HandyJSON {
    var Aggregated: Bool!
    var TimeFrom: TimeInterval!
    var TimeTo: TimeInterval!
    var Data: [CryptocompareHistoryData]?
}

