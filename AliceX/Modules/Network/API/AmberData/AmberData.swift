//
//  AmberData.swift
//  AliceX
//
//  Created by lmcmz on 17/9/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import Moya

// Doc Address: https://docs.amberdata.io/reference#get-transaction

enum AmberData {
    case getTransactions(hash: String, network: Web3NetEnum)
}

extension AmberData: TargetType {
    var headers: [String: String]? {
        var keys: NSDictionary?
        guard let path = Bundle.main.path(forResource: "Keys", ofType: "plist") else {
            return nil
        }
        keys = NSDictionary(contentsOfFile: path)

//        "Content-Type": "application/json",
        var dict = ["x-api-key": keys!["AmberDataAPIKey"] as! String]

        switch self {
        case let .getTransactions(_, network):
            dict["x-amberdata-blockchain-id"] = String(network.chainID)
            return dict
        }
    }

    var baseURL: URL {
        return URL(string: "https://web3api.io/api/v1/")!
    }

    var path: String {
        switch self {
        case .getTransactions(let hash, _):
            return "transactions/\(hash)"
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
            return .requestPlain
        }
    }

    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
}
