//
//  Github.swift
//  AliceX
//
//  Created by lmcmz on 21/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Moya

let GithubAPI = MoyaProvider<Github>()

enum Github {
    case dappList
}

extension Github: TargetType {
    var headers: [String: String]? {
        return nil
    }

    var baseURL: URL {
        return URL(string: "https://raw.githubusercontent.com/alicedapp/")!
    }

    var path: String {
        switch self {
        case .dappList:
            #if DEBUG
                return "AliceX-iOS/Dev/DappList/dapps.json"
            #else
                return "AliceX-iOS/master/DappList/dapps.json"
            #endif
            
        }
    }

    var method: Moya.Method {
        return .get
    }

    var task: Task {
        return .requestPlain
    }

    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
}
