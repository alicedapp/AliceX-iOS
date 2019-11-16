//
//  UnWatchingCoinHelper.swift
//  AliceX
//
//  Created by lmcmz on 2/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import Haneke
import PromiseKit

class IgnoreCoinHelper {
    static let shared = IgnoreCoinHelper()

    var list: [Coin] = []
    var isEmpty: Bool = true

    init() {
//        loadFromCache()
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

    // TODO:
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

    func updateList(newList: [Coin]) {
        list = newList
        storeInCache()

//        postNotification()
    }

    func blockchainList() -> [Coin] {
        return list.filter { !$0.isERC20 }
    }

    func erc20List() -> [Coin] {
        return list.filter { $0.isERC20 }
    }
}

// MARK: - Cache

extension IgnoreCoinHelper {
    func loadFromCache() -> Promise<Void> {
        return Promise<Void> { _ in
            let cacheKey = "\(CacheKey.unWatchingList).\(WalletManager.wallet!.address)"
            Shared.stringCache.fetch(key: cacheKey).onSuccess { result in
                var watchingList: [Coin] = []
                let idList = result.split(separator: ",")
                for id in idList {
                    if id.count == 42, id.hasPrefix("0x") { // ERC20
                        let coin = Coin.ERC20(address: String(id))
                        watchingList.append(coin)
                    } else {
                        guard let chain = BlockChain(rawValue: String(id)) else {
                            continue
                        }
                        let coin = Coin.coin(chain: chain)
                        watchingList.append(coin)
                    }
                }
                self.list = watchingList
                self.isEmpty = false
            }.onFailure { _ in
                self.isEmpty = true
            }
        }
    }

    func storeInCache() {
        let cacheKey = "\(CacheKey.unWatchingList).\(WalletManager.wallet!.address)"
        let idList = list.compactMap { $0.id }.joined(separator: ",")
        Shared.stringCache.set(value: idList, key: cacheKey)
    }
}
