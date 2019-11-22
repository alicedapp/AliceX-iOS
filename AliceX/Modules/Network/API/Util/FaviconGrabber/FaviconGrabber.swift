//
//  FaviconGrabber.swift
//  AliceX
//
//  Created by lmcmz on 20/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//
import Moya

let FaviconGrabberAPI = MoyaProvider<FaviconGrabber>()

enum FaviconGrabber {
    case favicon(domain: String)
}

extension FaviconGrabber: TargetType {
    var headers: [String: String]? {
        return nil
    }

    var baseURL: URL {
        return URL(string: "http://favicongrabber.com/api/grab/")!
    }

    var path: String {
        switch self {
        case let .favicon(domain):
            return "\(domain)"
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
