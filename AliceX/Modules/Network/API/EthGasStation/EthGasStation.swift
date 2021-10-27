//
//  EthGasStation.swift
//  AliceX
//
//  Created by lmcmz on 19/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import Moya

let gasStationAPI = MoyaProvider<EthGasStation>(plugins: [VerbosePlugin(verbose: true)])

enum EthGasStation {
    case gas
}

extension EthGasStation: TargetType {
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }

    var baseURL: URL {
        return URL(string: "https://ethgasstation.info/")!
    }

    var path: String {
        switch self {
        case .gas:
            return "json/ethgasAPI.json"
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
        case .gas:
            return .requestPlain
        }
    }

    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
}
