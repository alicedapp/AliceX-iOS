//
//  WatchingCoinHelper.swift
//  AliceX
//
//  Created by lmcmz on 2/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import Haneke
// import RxSwift
import PromiseKit

class WatchingCoinHelper {
    static let shared = WatchingCoinHelper()

    var list: [Coin] = []
//    var balance: [String: Double] = [:]
    var noCache: Bool = false

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(walletChange), name: .walletChange, object: nil)
    }

    @objc func walletChange() {
        list.removeAll()
        loadFromCache()
    }

    func add(coin: Coin, updateCache: Bool = false, checkIgnore: Bool = true) {
        if list.contains(coin) {
            let index = list.firstIndex(of: coin)
            list[index!] = coin
            return
        }

        if checkIgnore, IgnoreCoinHelper.shared.list.contains(coin) {
            IgnoreCoinHelper.shared.remove(coin: coin)
            let pinList = list.filter { $0.info!.isPined }
            let index = pinList.count
            list.insert(coin, at: index)
            storeInCache()
            postNotification()
            return
        }

        if let info = coin.info, info.isPined {
            list.insert(coin, at: 0)
        } else {
            let pinList = list.filter { $0.info!.isPined }
            let index = pinList.count
            list.insert(coin, at: index)
        }

        if updateCache {
            storeInCache()
            postNotification()
        }
    }

    // TODO:
//    func add(list: [Coin]) {
//        if list.contains(coin) {
//            return
//        }
//        list.append(lis)
//        storeInCache()
//    }

    func remove(coin: Coin, updateCache: Bool = false) {
        if !list.contains(coin) {
            return
        }
        guard let index = list.firstIndex(of: coin) else {
            return
        }
        list.remove(at: index)

        if updateCache {
            storeInCache()
            postNotification()
        }
    }

    func updateList(newList: [Coin]) {
//        for coin in newList {
//            if
//        }

        list = newList
        storeInCache()
        postNotification()
    }

    func blockchainList() -> [BlockChain] {
        let chains = list.filter { !$0.isERC20 }
        let result = chains.compactMap { coin in
            coin.blockchain
        }
        return result
    }

    func fetchList() -> Promise<[Coin]> {
        return Promise<[Coin]> { _ in
        }
    }

    func erc20List() -> [Coin] {
        return list.filter { $0.isERC20 }
    }

    func sortByPrice() {
        let pinList = list.filter { $0.info!.isPined }
        let unPinList = list.filter { !$0.info!.isPined }

        let sortedPin = pinList.sorted { (coin1, coin2) -> Bool in
            guard let info1 = coin1.info, let info2 = coin2.info else {
                return false
            }
            return info1.balance > info2.balance
        }

        let sortedUnPin = unPinList.sorted { (coin1, coin2) -> Bool in
            guard let info1 = coin1.info, let info2 = coin2.info else {
                return false
            }
            return info1.balance > info2.balance
        }

        list = sortedPin + sortedUnPin
        storeInCache()
    }
}

// MARK: - Cache

extension WatchingCoinHelper {
    func loadFromCache() -> Promise<[Coin]> {
        if !WalletManager.hasWallet() {
            return Promise<[Coin]> { seal in seal.reject(MyError.FoundNil("No wallet")) }
        }

        return Promise<[Coin]> { seal in
            let cacheKey = "\(CacheKey.watchingList).\(WalletManager.wallet!.address)"
            Shared.stringCache.fetch(key: cacheKey).onSuccess { result in
                var watchingList: [Coin] = []
                let idList = result.split(separator: ",")
                for id in idList {
                    if id.count == 42, id.hasPrefix("0x") { // ERC20
                        let coin = Coin.ERC20(address: String(id))
//                        self.add(coin: coin)
                        watchingList.append(coin)
                    } else {
                        guard let chain = BlockChain(rawValue: String(id)) else {
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
                if let err = error, err._code == -100 {
                    self.noCache = true
                    self.list = [Coin.coin(chain: .Ethereum)]
                    seal.fulfill(self.list)
                } else {
                    seal.reject(error ?? MyError.FoundNil("Fetch Cache Failed: \(cacheKey)"))
                }
            }
        }
    }

    func postNotification() {
        NotificationCenter.default.post(name: .watchingCoinListChange, object: nil)
    }

    func storeInCache() {
        let cacheKey = "\(CacheKey.watchingList).\(WalletManager.wallet!.address)"
        let idList = list.compactMap { $0.id }.joined(separator: ",")
        Shared.stringCache.set(value: idList, key: cacheKey)
    }
}
