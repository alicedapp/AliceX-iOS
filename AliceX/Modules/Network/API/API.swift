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
    case DecodeFailed
}

func API<T: HandyJSON, U: TargetType>(_ target: U,
                                      showLoading _: Bool = false,
                                      showErrorHUD _: Bool = false,
                                      useCache _: Bool = false) -> Promise<T> {
    return Promise<T> { seal in
        #if DEBUG
        let provider = MoyaProvider<U>(plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)])
        #else
        let provider = MoyaProvider<U>()
        #endif
        provider.request(target, completion: { result in
            switch result {
            case let .success(response):
//                do {
                    // TODO: TokenInfo Mapping faild, but not nil
                    guard let model = response.mapObject(T.self) else {
                        seal.reject(MyError.DecodeFailed)
                        return
                    }
//                        try T.deserialize(from: response.mapString())
                    
                    seal.fulfill(model)
//                } catch {
//                    seal.reject(MyError.DecodeFailed)
//                }
                
            case let .failure(error):
                seal.reject(error)
            }
        })
    }
}

func API<T: Decodable, U: TargetType>(_ target: U,
                                      showLoading _: Bool = false,
                                      showErrorHUD _: Bool = false,
                                      useCache _: Bool = false) -> Promise<T> {
    return Promise<T> { seal in
        #if DEBUG
        let provider = MoyaProvider<U>(plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)])
        #else
        let provider = MoyaProvider<U>()
        #endif
        provider.request(target, completion: { result in
            switch result {
            case let .success(response):
                do {
                    let model = try JSONDecoder().decode(T.self, from: response.data)
                    seal.fulfill(model)
                } catch {
                    seal.reject(MyError.DecodeFailed)
                }
            case let .failure(error):
                seal.reject(error)
            }
        })
    }
}
