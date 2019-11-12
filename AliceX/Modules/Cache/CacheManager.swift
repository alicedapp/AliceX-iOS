//
//  CacheManager.swift
//  AliceX
//
//  Created by lmcmz on 12/9/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import HandyJSON
// import Haneke

//typealias CacheManger.storage = CacheManger.shared.storage

class CacheManager {
    static let shared = CacheManager()

//    var storage: Storage<Codable>?
//
    init() {
//        Shared.dataCache
    }

//
//    func removeAllCache(completion: @escaping (_ isSuccess: Bool)->()) {
//        storage?.async.removeAll(completion: { result in
//            DispatchQueue.main.async {
//                switch result {
//                case .value: completion(true)
//                case .error: completion(false)
//                }
//            }
//        })
//    }
//
//    func removeObjectCache(_ cacheKey: String, completion: @escaping (_ isSuccess: Bool)->()) {
//        storage?.async.removeObject(forKey: cacheKey, completion: { result in
//            DispatchQueue.main.async {
//                switch result {
//                case .value: completion(true)
//                case .error: completion(false)
//                }
//            }
//        })
//    }
//
//    func objectSync(forKey key: String) -> CacheModel? {
//        do {
//            ///过期清除缓存
//            if let isExpire = try storage?.isExpiredObject(forKey: key), isExpire {
//                removeObjectCache(key) { (_) in }
//                return nil
//            } else {
//                return (try storage?.object(forKey: key)) ?? nil
//            }
//        } catch {
//            return nil
//        }
//    }
//
//    func setObject(_ object: CacheModel, forKey key: String) {
//        storage?.async.setObject(object, forKey: key, expiry: nil, completion: { (result) in
//            switch result {
//            case .value(_):
//                DaisyLog("缓存成功")
//            case .error(let error):
//                DaisyLog("缓存失败: \(error)")
//            }
//        })
//    }
}
