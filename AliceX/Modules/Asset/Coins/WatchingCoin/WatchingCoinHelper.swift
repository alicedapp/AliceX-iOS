//
//  WatchingCoinHelper.swift
//  AliceX
//
//  Created by lmcmz on 2/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import Haneke
import RxSwift
import PromiseKit

class WatchingCoinHelper {
    
    static let shared = WatchingCoinHelper()
    
    var list: [Coin] = []
    var balance: [String: Double] = [:]
//    var walletAddress:String = WalletManager.wallet!.address
    
    init() {
    }
    
    func add(coin: Coin, updateCache: Bool = false, checkIgnore: Bool = true) {
        if list.contains(coin) {
            let index = list.firstIndex(of: coin)
            list[index!] = coin
            return
        }
        
        if checkIgnore && UnWatchingCoinHelper.shared.list.contains(coin) {
            return
        }
        
        list.insert(coin, at: 0)
        
        if updateCache {
            storeInCache()
            self.postNotification()
        }
    }
    
    // TODO
//    func add(list: [Coin]) {
//        if list.contains(coin) {
//            return
//        }
//        list.append(lis)
//        storeInCache()
//    }
    
    func remove(coin: Coin) {
        if !list.contains(coin) {
            return
        }
        guard let index = list.firstIndex(of: coin) else {
            return
        }
        list.remove(at: index)
        storeInCache()
        self.postNotification()
    }
    
    func blockchainList() -> [BlockChain] {
        let chains = list.filter { !$0.isERC20 }
        let result = chains.compactMap { coin in
            coin.blockchain
        }
        return result
    }
    
    func fetchList() -> Promise<[Coin]> {
        return Promise<[Coin]> { seal in
            
        }
    }
    
    func erc20List() -> [Coin] {
        return list.filter { $0.isERC20 }
    }
    
    func sortByPrice() {
        let sorted = list.sorted { (coin1, coin2) -> Bool in
            guard let info1 = coin1.info, let info2 = coin2.info else {
                return false
            }
            return info1.balance > info2.balance
        }
        list = sorted
    }
    
}

// MARK: - Cache
extension WatchingCoinHelper {
    
    func loadFromCache() -> Promise<[Coin]> {
        
        return Promise<[Coin]> { seal in
            let cacheKey = "\(CacheKey.watchingList).\(WalletManager.wallet!.address)"
            Shared.stringCache.fetch(key: cacheKey).onSuccess { result in
                var watchingList: [Coin] = []
                let idList = result.split(separator: ",")
                for id in idList {
                    if id.count == 42 && id.hasPrefix("0x") { // ERC20
                        let coin = Coin.ERC20(address: String(id))
//                        self.add(coin: coin)
                        watchingList.append(coin)
                    } else {
                        guard let chain = BlockChain(rawValue: String(id)) else{
                            continue
                        }
                        let coin = Coin.coin(chain: chain)
//                        self.add(coin: coin)
                        watchingList.append(coin)
                    }
                }
                self.list = watchingList
                seal.fulfill(watchingList)
            }.onFailure { error in
                seal.reject(error ?? MyError.FoundNil("Fetch Cache Failed: \(cacheKey)"))
            }
        }
    }
    
    func postNotification()  {
        NotificationCenter.default.post(name: .watchingCoinListChange, object: nil)
    }
    
    func storeInCache() {
        let cacheKey = "\(CacheKey.watchingList).\(WalletManager.wallet!.address)"
        let idList = list.compactMap { $0.id }.joined(separator: ",")
        Shared.stringCache.set(value: idList, key: cacheKey)
    }
}
