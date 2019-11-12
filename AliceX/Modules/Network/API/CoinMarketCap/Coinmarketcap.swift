//
//  Coinmarketcap.swift
//  AliceX
//
//  Created by lmcmz on 18/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import Moya

typealias SuccessCallback = ((Response) -> Void)

let coinMarketCapAPI = MoyaProvider<CoinMarketCap>()
//NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)

// Due to Coinmarketcap plan, just support ETH in
enum CoinMarketCap {
    case latest(currency: Currency)
    case quote(currency: Currency)
}

extension CoinMarketCap: TargetType {
    var headers: [String: String]? {
        return ["Content-Type": "application/json",
                "X-CMC_PRO_API_KEY": "708fac2a-a6fa-43b2-861f-ce58a82f74b5"]
    }

    var baseURL: URL {
        return URL(string: "https://pro-api.coinmarketcap.com/")!
    }

    var path: String {
        switch self {
        case .latest:
            return "v1/cryptocurrency/listings/latest"
        case .quote:
            return "v1/cryptocurrency/quotes/latest"
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
        case let .latest(currency):
            let dict = ["start": 2, "limit": 1, "convert": currency.rawValue] as [String: Any]
            return .requestParameters(parameters: dict, encoding: URLEncoding.queryString)

        case let .quote(currency):
            let array = BlockChain.allCases.compactMap { String($0.coinMaeketCapID) }
            let ids = array.joined(separator: ",")
            let dict = ["id": ids, "convert": currency.rawValue] as [String: Any]
            return .requestParameters(parameters: dict, encoding: URLEncoding.queryString)
        }
    }

    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
}
