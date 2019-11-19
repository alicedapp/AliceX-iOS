//
//  CoinInfoCenter.swift
//  AliceX
//
//  Created by lmcmz on 6/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import Haneke
import PromiseKit

class CoinInfoCenter {
    static let shared = CoinInfoCenter()
    var pool: [String: CoinInfo] = [:]

    init() {
        // TODO:
    }

    func add(info: CoinInfo) {
//        if pool.keys.contains(info.id) {
//        }
        pool[info.id] = info
    }

    func update(newInfo: CoinInfo) {
        if !pool.keys.contains(newInfo.id) {
            pool[newInfo.id] = newInfo
            return
        }
        var info = pool[newInfo.id]!
        info.symbol = newInfo.symbol
        info.decimals = newInfo.decimals
        info.name = newInfo.name
        info.id = newInfo.id
        info.amount = newInfo.amount
        pool[newInfo.id] = info
    }

    func pin(coin: Coin) {
        guard var info = pool[coin.id] else {
            return
        }
        info.isPined = true
        pool[info.id] = info
//        storeInCache()
    }

    func unpin(coin: Coin) {
        guard var info = pool[coin.id] else {
            return
        }
        info.isPined = false
        pool[info.id] = info
//        storeInCache()
    }

//    func fetchingCoin(coin: Coin) -> Promise<CoinInfo> {
//
//        return Promise<CoinInfo> { seal in
//
//            if pool.keys.contains(coin.id) {
//                seal.fulfill(pool[coin.id]!)
//                return
//            }
//
//            // TODO
//
//        }
//    }

    func requestToken(address: String) -> Promise<CoinInfo> {
        return Promise<CoinInfo> { seal in
            firstly { () -> Promise<AmberdataTokenPrice> in
                API(AmberData.tokenPrice(address: address, currency: PriceHelper.shared.currentCurrency))
            }.done { model in
                var info = CoinInfo()
                info.id = model.address
                info.name = model.name
                seal.fulfill(info)
            }
        }
    }
}

extension CoinInfoCenter {
    func loadFromCache() -> Promise<Bool> {
//        if !WalletManager.hasWallet() {
//            return Promise<Void> { seal in seal.reject(MyError.FoundNil("No wallet")) }
//        }

        return Promise<Bool> { seal in

            let cacheKey = CacheKey.coinInfoList
//            "\(CacheKey.coinInfoList).\(WalletManager.wallet!.address)"
            Shared.stringCache.fetch(key: cacheKey).onSuccess { result in
                guard let modelArray = [CoinInfo].deserialize(from: result) else {
                    seal.reject(MyError.DecodeFailed)
                    return
                }

                modelArray.forEach { info in
                    self.pool[info!.id] = info
                }

                seal.fulfill(true)

            }.onFailure { error in
                seal.reject(error ?? MyError.FoundNil("Fetch Cache Failed: \(cacheKey)"))
                Shared.stringCache.remove(key: cacheKey)

                BlockChain.allCases.forEach { chain in
                    //            let coin = Coin.coin(chain: chain)
                    var info = CoinInfo()
                    info.id = chain.rawValue
                    info.name = chain.rawValue
                    info.decimals = chain.decimal
                    info.symbol = chain.symbol
                    self.pool[info.id] = info

                    if WatchingCoinHelper.shared.noCache, chain == .Ethereum {
                        info.isPined = true
                    }

                    chain.getBalance().done { balance in
                        info.amount = String(balance)
                        if let price = self.pool[info.id]?.price {
                            info.price = price
                        }
                        self.pool[info.id] = info
                    }
                }

                let bundlePath = Bundle.main.path(forResource: "erc20", ofType: "json")
                let jsonString = try! String(contentsOfFile: bundlePath!)
                let coinInfoList = [CoinInfo].deserialize(from: jsonString) as! [CoinInfo]
                coinInfoList.forEach { info in
                    self.pool[info.id] = info
                }
            }
        }
    }

    func storeInCache() {
        if pool.keys.count <= 0 {
            return
        }

//        let cacheKey = "\(CacheKey.).\(WalletManager.wallet!.address)"
        let values = Array(pool.values)
        guard let jsonString = values.toJSONString() else {
            return
        }
        Shared.stringCache.set(value: jsonString, key: CacheKey.coinInfoList)
    }
}
