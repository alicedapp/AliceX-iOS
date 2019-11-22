//
//  QuerySuggest.swift
//  AliceX
//
//  Created by lmcmz on 22/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import Moya
import HandyJSON

struct QuerySuggestModel: HandyJSON {
    var phrase: String!
}

let QuerySuggestAPI = MoyaProvider<QuerySuggest>()

enum QuerySuggest {
    case query(text: String)
}

extension QuerySuggest: TargetType {
    var headers: [String: String]? {
        return nil
    }

    var baseURL: URL {
        return URL(string: "https://ac.duckduckgo.com/")!
    }

    var path: String {
        switch self {
        case .query:
            return "ac/"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var task: Task {
        switch self {
        case .query(let query):
            let dict = ["q" : query, "type" : "json"]
            return .requestParameters(parameters: dict, encoding: URLEncoding.queryString)
        }
    }

    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
}
