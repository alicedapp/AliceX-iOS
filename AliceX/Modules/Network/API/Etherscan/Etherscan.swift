//
//  Etherscan.swift
//  AliceX
//
//  Created by lmcmz on 9/2/20.
//  Copyright © 2020 lmcmz. All rights reserved.
//

import Foundation
import Moya

let EtherscanAPI = MoyaProvider<Github>()

enum Etherscan {
    case getABI(contractAddress: String)
}

extension Etherscan: TargetType {
    var headers: [String: String]? {
        return nil
    }

    var baseURL: URL {
        return URL(string: "https://api.etherscan.io/api")!
    }

    var path: String {
        switch self {
        case .getABI:
            return ""
        }
    }

    var method: Moya.Method {
        return .get
    }

    var task: Task {
        switch self {
        case let .getABI(contractAddress):
            return .requestParameters(parameters: ["module": "contract",
                                                   "action": "getabi",
                                                   "address": contractAddress,
                                                   "apikey": APIKey.etherscanKey],
                                      encoding: URLEncoding.queryString)
        default:
            return .requestPlain
        }
    }

    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
}
