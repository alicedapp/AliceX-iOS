//
//  Ethplorer.swift
//  AliceX
//
//  Created by lmcmz on 19/6/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Moya

// Doc Address: https://github.com/EverexIO/Ethplorer/wiki/Ethplorer-API

let ethplorerAPI = MoyaProvider<Ethplorer>(plugins: [VerbosePlugin(verbose: true)])

enum Ethplorer {
    case getTokenInfo(address: String)
    case getAddressInfo(address: String)
    case getTxInfo(TXHash: String)
    case getTokenHistory(TXHash: String)
    case getAddressHistory(address: String)
    case getTop
    case getTopTokens
    case getTopTokenHolders(address: String)
    case getTokenHistoryGrouped(address: String)
    case getTokenPriceHistoryGrouped(address: String)
}

extension Ethplorer: TargetType {
    var headers: [String: String]? {
        switch self {
        default:
            return ["Content-Type": "application/json"]
        }
    }

    var baseURL: URL {
        return URL(string: "https://api.ethplorer.io/")!
    }

    var path: String {
        switch self {
        case let .getAddressInfo(address):
            return "getAddressInfo/\(address)"
        case let .getTokenInfo(address):
            return "getTokenInfo/\(address)"
        case let .getTxInfo(hash):
            return "getTxInfo/\(hash)"
        case let .getAddressHistory(address):
            return "/getAddressTransactions/\(address)"
        case .getTop:
            return "/getTop"
        default:
            return ""
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
        default:
            let dict = ["apiKey": "freekey"]
            return .requestParameters(parameters: dict, encoding: URLEncoding.queryString)
        }
    }

    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
}
