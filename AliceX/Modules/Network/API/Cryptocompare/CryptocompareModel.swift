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
    var CHANGEPCT24HOUR: Double!
    
    var OPEN24HOUR: Double!
    var HIGH24HOUR: Double!
    var LOW24HOUR: Double!
    var VOLUME24HOUR: NSNumber!
    var VOLUME24HOURTO: NSNumber!
    var LASTUPDATE: TimeInterval!
    
    var LASTMARKET: String!
    
    var SUPPLY: NSNumber!
    var MKTCAP: NSNumber!
}

struct CryptocompareDisplayModel: HandyJSON {
    var MARKET: String!
    var FROMSYMBOL: String!
    var TOSYMBOL: String!
    var PRICE: String!
    var CHANGE24HOUR: String!
    var CHANGEPCT24HOUR: String!
    
    var OPEN24HOUR: String!
    var HIGH24HOUR: String!
    var LOW24HOUR: String!
    var VOLUME24HOUR: String!
    var VOLUME24HOURTO: String!
    var LASTUPDATE: String!
    
    var SUPPLY: String!
    var MKTCAP: String!
}

struct CryptocompareHistoryData: HandyJSON {
    var time: TimeInterval!
    var high: Double!
    var low: Double!
    var open: Double!
    var close: Double!
    var volumefrom: NSNumber!
    var volumeto: NSNumber!
    
    var conversionType: String?
    var conversionSymbol: String?
}

struct CryptocompareHistoryModel: HandyJSON {
    var Aggregated: Bool!
    var TimeFrom: TimeInterval!
    var TimeTo: TimeInterval!
    var Data: [CryptocompareHistoryData]?
}

