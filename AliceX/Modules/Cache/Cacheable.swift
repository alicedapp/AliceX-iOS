//
//  Cacheable.swift
//  AliceX
//
//  Created by lmcmz on 22/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import PromiseKit
import Haneke
import HandyJSON

protocol Cacheable {
    func cacheKey() -> CacheKey
    func loadFromCache() -> String
    func storeInCahe(jsonString: String)
}

//class CacheableObject: Cacheable {
//    func cacheKey() -> CacheKey {
//        return .
//    }
//
//    func loadFromCache() {
//        <#code#>
//    }
//
//    func storeInCahe() {
//        <#code#>
//    }
//}
