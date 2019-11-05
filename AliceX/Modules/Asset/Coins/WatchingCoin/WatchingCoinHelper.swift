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

class WatchingCoinHelper {
    static let shared = WatchingCoinHelper()
    
    var list: [Coin] = []
    var isEmpty: Bool = true
    
    init() {
//        loadFromCache()
//        Observable.from(list)
    }
    
    func add(coin: Coin) {
        if list.contains(coin) {
            let index = list.firstIndex(of: coin)
            list[index!] = coin
            return
        }
        list.append(coin)
        storeInCache()
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
    }
    
    func blockchainList() -> [BlockChain] {
        let chains = list.filter { !$0.isERC20 }
        let result = chains.compactMap { coin in
            coin.blockchain
        }
        return result
    }
    
    func chainList() -> [Coin] {
        return list.filter { !$0.isERC20 }
    }
    
    func erc20List() -> [Coin] {
        return list.filter { $0.isERC20 }
    }
}

// MARK: - Cache
extension WatchingCoinHelper {
    
    func loadFromCache() {
        Shared.stringCache.fetch(key: CacheKey.watchingList).onSuccess { result in
            var watchingList: [Coin] = []
            let idList = result.split(separator: ",")
            for id in idList {
                if id.count == 42 && id.hasPrefix("0x") { // ERC20
                    let token = ERC20(address: String(id))
                    let coin = Coin.ERC20(token: token)
                    watchingList.append(coin)
                } else {
                    guard let chain = BlockChain(rawValue: String(id)) else{
                        continue
                    }
                    let coin = Coin.coin(chain: chain)
                    watchingList.append(coin)
                }
            }
            self.list = watchingList
            self.isEmpty = false
            self.postNotification()
        }.onFailure { (error) in
            self.isEmpty = true
        }
    }
    
    func postNotification()  {
        NotificationCenter.default.post(name: .watchingCoinListChange, object: nil)
    }
    
    func storeInCache() {
        let idList = list.compactMap { $0.id }.joined(separator: ",")
        Shared.stringCache.set(value: idList, key: CacheKey.watchingList)
    }
}
