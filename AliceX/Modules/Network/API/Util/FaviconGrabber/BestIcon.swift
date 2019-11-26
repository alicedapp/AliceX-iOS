//
//  BestIcon.swift
//  AliceX
//
//  Created by lmcmz on 22/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import Moya

let BestIconAPI = MoyaProvider<BestIcon>()

enum BestIcon {
    case favicon(domain: String)
}

extension BestIcon: TargetType {
    var headers: [String: String]? {
        return nil
    }

    var baseURL: URL {
        return URL(string: "https://besticon-demo.herokuapp.com/")!
    }

    var path: String {
        return "icon"
    }

    var method: Moya.Method {
        return .get
    }

    var task: Task {
        switch self {
        case .favicon(let domain):
            let paras = ["url": domain, "size" : "120"]
            return .requestParameters(parameters: paras, encoding: URLEncoding.queryString )
        }
    }

    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
}
