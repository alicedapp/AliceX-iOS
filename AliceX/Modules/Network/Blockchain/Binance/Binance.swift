//
//  Binance.swift
//  AliceX
//
//  Created by lmcmz on 28/10/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Moya

// Doc Address: https://docs.binance.org/api-reference/dex-api/paths.html

let BNBProvider = MoyaProvider<BNBAPI>(plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)])

enum BNBAPI {
    case nodeInfo
    case sequence(address: String)
    case account(address: String)
    case broadcast(data: Data)
    case transactions(address: String, startTime: TimeInterval, endTime: TimeInterval)
}

extension BNBAPI: TargetType {
    var headers: [String: String]? {
        switch self {
        case .broadcast:
            return ["Content-Type": "text/plain"]
        default:
            return ["Content-Type": "application/json"]
        }
    }

    var baseURL: URL {
//        #if DEBUG
//        return URL(string: "https://testnet-dex.binance.org/api/v1/")!
//        #else
        return URL(string: "https://dex.binance.org/api/v1/")!
//        #endif
    }

    var path: String {
        switch self {
        case .nodeInfo:
            return "node-info"
        case let .sequence(address):
            return "account/\(address)/sequence"
        case let .account(address):
            return "account/\(address)"
        case .broadcast:
            return "broadcast"
        case .transactions:
            return "transactions"
        }
    }

    var method: Moya.Method {
        switch self {
        case .broadcast:
            return .post
        default:
            return .get
        }
    }

    var task: Task {
        switch self {
        case let .broadcast(data):
            return .requestCompositeData(bodyData: data, urlParameters: ["sync": true])
        case let .transactions(address, startTime, endTime):
            let dict = ["address": address, "startTime": Int64(startTime * 1000), "endTime": Int64(endTime * 1000)] as [String: Any]
            return .requestParameters(parameters: dict, encoding: URLEncoding.queryString)
        default:
            return .requestPlain
        }
    }

    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
}
