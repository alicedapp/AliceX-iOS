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

// func API<T: HandyJSON, U: TargetType>(_ target: U, path: String? = nil,
//                                      showLoading _: Bool = false,
//                                      showErrorHUD _: Bool = false,
//                                      useCache _: Bool = false) -> Promise<T> {
//    return Promise<T> { seal in
////        #if DEBUG
////            let provider = MoyaProvider<U>(plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)])
////        #else
//        let provider = MoyaProvider<U>()
////        #endif
//        provider.request(target, completion: { result in
//            switch result {
//            case let .success(response):
////                do {
//                // TODO: TokenInfo Mapping faild, but not nil
//
//                if let designPath = path, !designPath.isEmptyAfterTrim() {
//                    guard let model = response.mapObject(T.self, designatedPath: designPath) else {
//                        seal.reject(MyError.DecodeFailed)
//                        return
//                    }
//                    seal.fulfill(model)
//
//                } else {
//                    guard let model = response.mapObject(T.self) else {
//                        seal.reject(MyError.DecodeFailed)
//                        return
//                    }
//                    seal.fulfill(model)
//                }
//
////                } catch {
////                    seal.reject(MyError.DecodeFailed)
////                }
//
//            case let .failure(error):
//                seal.reject(error)
//            }
//        })
//    }
// }

// func API<T: HandyJSON, U: TargetType>(_ target: U, path: String? = nil,
//                                      showLoading _: Bool = false,
//                                      showErrorHUD _: Bool = false,
//                                      useCache _: Bool = false) -> Promise<[T?]> {
//    return Promise<[T?]> { seal in
////        #if DEBUG
////            let provider = MoyaProvider<U>(plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)])
////        #else
//        let provider = MoyaProvider<U>()
////        #endif
//        provider.request(target, completion: { result in
//            switch result {
//            case let .success(response):
////                do {
//                // TODO: TokenInfo Mapping faild, but not nil
//
//                if let designPath = path, !designPath.isEmptyAfterTrim() {
//                    guard let model = response.mapArray(T.self, designatedPath: designPath) else {
//                        seal.reject(MyError.DecodeFailed)
//                        return
//                    }
//                    seal.fulfill(model)
//
//                } else {
//                    guard let model = response.mapArray(T.self) else {
//                        seal.reject(MyError.DecodeFailed)
//                        return
//                    }
//                    seal.fulfill(model)
//                }
//
////                } catch {
////                    seal.reject(MyError.DecodeFailed)
////                }
//
//            case let .failure(error):
//                seal.reject(error)
//            }
//        })
//    }
// }

func API<T: HandyJSON, U: TargetType>(_ target: U, path: String? = nil) -> Promise<T> {
    return Promise<T> { seal in
        let provider = MoyaProvider<U>(plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)])
        provider.request(target, completion: { result in
            switch result {
            case let .success(response):

                if let designPath = path, !designPath.isEmpty {
                    guard let model = response.mapObject(T.self, designatedPath: designPath) else {
                        seal.reject(MyError.DecodeFailed)
                        return
                    }
                    seal.fulfill(model)

                } else {
                    guard let model = response.mapObject(T.self) else {
                        seal.reject(MyError.DecodeFailed)
                        return
                    }
                    seal.fulfill(model)
                }

            case let .failure(error):
                seal.reject(error)
            }
        })
    }
}

func API<T: HandyJSON, U: TargetType>(_ target: U, path: String? = nil) -> Promise<[T?]> {
    return Promise<[T?]> { seal in

        let provider = MoyaProvider<U>(plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)])

        provider.request(target, completion: { result in
            switch result {
            case let .success(response):

                if let designPath = path, !designPath.isEmpty {
                    guard let model = response.mapArray(T.self, designatedPath: designPath) else {
                        seal.reject(MyError.DecodeFailed)
                        return
                    }
                    seal.fulfill(model)

                } else {
                    guard let model = response.mapArray(T.self) else {
                        seal.reject(MyError.DecodeFailed)
                        return
                    }
                    seal.fulfill(model)
                }

            case let .failure(error):
                seal.reject(error)
            }
        })
    }
}

func API<U: TargetType>(_ target: U, path _: String? = nil) -> Promise<String> {
    return Promise<String> { seal in

        let provider = MoyaProvider<U>(plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)])

        provider.request(target, completion: { result in
            switch result {
            case let .success(response):

                guard let dataString = String(data: response.data, encoding: .utf8) else {
                    seal.reject(MyError.DecodeFailed)
                    return
                }

                seal.fulfill(dataString)

            case let .failure(error):
                seal.reject(error)
            }
        })
    }
}
