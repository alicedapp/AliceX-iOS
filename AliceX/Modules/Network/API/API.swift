//
//  API.swift
//  AliceX
//
//  Created by lmcmz on 19/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import PromiseKit
import Moya
import HandyJSON

public protocol BasicResponseProtocol: HandyJSON {
}

enum MyError: Error {
    case FoundNil(String)
}

func API<T: HandyJSON, U: TargetType>(_ target: U,
                                      showLoading: Bool = false,
                                      showErrorHUD: Bool = false,
                                      useCache: Bool = false) -> Promise<T> {
    return Promise<T> { seal in
        let provider = MoyaProvider<U>()
        provider.request(target, completion: { (result) in
            switch result {
            case let .success(response):
                let model = try! T.deserialize(from: response.mapString())
                seal.fulfill(model!)
            case .failure(let error):
                seal.reject(error)
            }
        })
    }
}
