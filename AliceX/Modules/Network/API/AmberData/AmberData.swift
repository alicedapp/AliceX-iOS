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
    case getTransactions(hash: String, blokchain: BlockChain)
    case tokenPrice(address: String, currency: Currency)
    case accountBalance(address: String, blockchain: BlockChain)
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
        case let .getTransactions(_, chain):
            dict["x-amberdata-blockchain-id"] = chain.amberDataID
            return dict
        case let .accountBalance(_, chain):
            dict["x-amberdata-blockchain-id"] = chain.amberDataID
            return dict
        default:
            return dict
        }
    }

    var baseURL: URL {
        return URL(string: "https://web3api.io/api/v2/")!
    }

    var path: String {
        switch self {
        case .getTransactions(let hash):
            return "transactions/\(hash)"
        case let .tokenPrice(address, _):
            return "market/tokens/prices/\(address)/latest"
        case let .accountBalance(address, _):
            return "addresses/\(address)/account-balances/latest"
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
