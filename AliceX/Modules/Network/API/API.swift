//
//  API.swift
//  AliceX
//
//  Created by lmcmz on 19/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import HandyJSON
import Moya
import PromiseKit

public protocol BasicResponseProtocol: HandyJSON {}

enum MyError: Error {
    case FoundNil(String)
}

func API<T: HandyJSON, U: TargetType>(_ target: U,
                                      showLoading _: Bool = false,
                                      showErrorHUD _: Bool = false,
                                      useCache _: Bool = false) -> Promise<T> {
    return Promise<T> { seal in
        let provider = MoyaProvider<U>()
        provider.request(target, completion: { result in
            switch result {
            case let .success(response):
                let model = try! T.deserialize(from: response.mapString())
                seal.fulfill(model!)
            case let .failure(error):
                seal.reject(error)
            }
        })
    }
}
