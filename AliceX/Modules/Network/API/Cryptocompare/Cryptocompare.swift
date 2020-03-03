//
//  Cryptocompare.swift
//  AliceX
//
//  Created by lmcmz on 4/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import Moya

let CryptocompareAPI = MoyaProvider<Cryptocompare>()
// (plugins:[NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)])

/// https://min-api.cryptocompare.com/documentation?key=Historical&cat=dataHistoday
enum Cryptocompare {
    case price(symbol: [String], currency: Currency)
    case fullPrice(symbol: [String], currency: Currency)
    case historyDay(symbol: String, currency: Currency, limit: Int, allData: Bool)
    case historyHour(symbol: String, currency: Currency, limit: Int)
}

extension Cryptocompare: TargetType {
    var headers: [String: String]? {
        return ["Content-Type": "application/json", "Authorization": "15a891fab6d39607a6fd5b821787dc608114837d7e4e6a200c88ef0e13b21713"]
    }

    var baseURL: URL {
        return URL(string: "https://min-api.cryptocompare.com/")!
    }

    var path: String {
        switch self {
        case .price:
            return "data/pricemulti"
        case .fullPrice:
            return "data/pricemultifull"
        case .historyDay:
            return "data/v2/histoday"
        case .historyHour:
            return "data/v2/histohour"
        }
    }

    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }

    var task: Task {
        switch self {
        case let .price(symbols, currency):
            let dict = ["fsyms": symbols.joined(separator: ","), "tsyms": currency.rawValue]
            return .requestParameters(parameters: dict, encoding: URLEncoding.queryString)
        case let .fullPrice(symbols, currency):
            let dict = ["fsyms": symbols.joined(separator: ","), "tsyms": currency.rawValue]
            return .requestParameters(parameters: dict, encoding: URLEncoding.queryString)
        case let .historyHour(symbol, currency, limit):
            let dict = ["fsym": symbol.uppercased(), "tsym": currency.rawValue, "limit": limit] as [String: Any]
            return .requestParameters(parameters: dict, encoding: URLEncoding.queryString)
        case let .historyDay(symbol, currency, limit, allData):
            let dict = ["fsym": symbol.uppercased(), "tsym": currency.rawValue, "limit": limit, "allData": allData] as [String: Any]
            return .requestParameters(parameters: dict, encoding: URLEncoding.queryString)
        }
    }

    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
}
