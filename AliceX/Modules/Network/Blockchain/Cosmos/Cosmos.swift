//
//  Cosmos.swift
//  AliceX
//
//  Created by lmcmz on 15/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Moya

// Doc Address: https://cosmos.network/rpc/#/ICS20/get_bank_balances__address_

enum CosmosAPI {
    case balance(address: String)
}

extension CosmosAPI: TargetType {
    var headers: [String: String]? {
        switch self {
        default:
            return ["Content-Type": "application/json"]
        }
    }

    var baseURL: URL {
        //        #if DEBUG
        //        return URL(string: "https://testnet-dex.binance.org/api/v1/")!
        //        #else
        return URL(string: "https://stargate.cosmos.network/")!
        //        #endif
    }

    var path: String {
        switch self {
        case let .balance(address):
            return "bank/balances/\(address)"
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
            return .requestPlain
        }
    }

    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
}
