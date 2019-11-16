//
//  OpenSeaAPI.swift
//  AliceX
//
//  Created by lmcmz on 28/10/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import Moya

let OpenSeaAPI = MoyaProvider<OpenSea>(plugins:
    [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)])

// Due to Coinmarketcap plan, just support ETH in
enum OpenSea {
    case assets(address: String)
}

extension OpenSea: TargetType {
    var headers: [String: String]? {
        return ["Content-Type": "application/json",
                "X-CMC_PRO_API_KEY": "bef62b077b104cee981849a010b70da2"]
    }

    var baseURL: URL {
        return URL(string: "https://api.opensea.io/api/")!
    }

    var path: String {
        switch self {
        case .assets:
            return "v1/assets"
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
        case let .assets(address):
            // TODO:
            let dict = ["owner": address, "limit": 200, "offset": 0] as [String: Any]
            return .requestParameters(parameters: dict, encoding: URLEncoding.queryString)
        }
    }

    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
}
