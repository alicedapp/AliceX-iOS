//
//  CoinMarketCapModel.swift
//  AliceX
//
//  Created by lmcmz on 18/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import HandyJSON

struct CoinMarketCapModel: HandyJSON {
    var data: [CoinMarketCapDataModel]?
}

// struct CoinMarketCapModelQuote: HandyJSON {
//    var data: [CoinMarketCapDataModel]?
// }

struct CoinMarketCapDataModel: HandyJSON {
    var id: Int!
    var name: String!
    var symbol: String!
    var slug: String!
    var last_updated: Date?
    var quote: CoinMarketCapQuoteModel?

    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            last_updated <-- CustomDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
    }
}

struct CoinMarketCapQuoteModel: HandyJSON {
    // TODO: More Currency Support
    var USD: CoinMarketCapCurrencyModel?
    var EUR: CoinMarketCapCurrencyModel?
    var CNY: CoinMarketCapCurrencyModel?
    var AUD: CoinMarketCapCurrencyModel?
    var CAD: CoinMarketCapCurrencyModel?
    var KRW: CoinMarketCapCurrencyModel?
    var HKD: CoinMarketCapCurrencyModel?
    var SGD: CoinMarketCapCurrencyModel?
    var RUB: CoinMarketCapCurrencyModel?
    var JPY: CoinMarketCapCurrencyModel?
    var TWD: CoinMarketCapCurrencyModel?
    var CHF: CoinMarketCapCurrencyModel?
    var MXN: CoinMarketCapCurrencyModel?
}

struct CoinMarketCapCurrencyModel: HandyJSON {
    var price: Float?
    var volume_24h: Float?
    var percent_change_1h: Float?
    var percent_change_24h: Float?
    var percent_change_7d: Float?
    var market_cap: Float?
    var last_updated: Date?
    var currency: Currency?

    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            last_updated <-- CustomDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
    }
}
