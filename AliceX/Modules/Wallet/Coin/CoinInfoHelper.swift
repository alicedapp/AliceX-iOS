//
//  CoinInfoHelper.swift
//  AliceX
//
//  Created by lmcmz on 6/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import Haneke
import PromiseKit

class CoinInfoHelper {
    static let shared = CoinInfoHelper()
    
    var pool: [String: CoinInfo] = [:]
    
    init() {
        
        BlockChain.allCases.forEach { chain in
//            let coin = Coin.coin(chain: chain)
            var info = CoinInfo()
            info.id = chain.rawValue
            info.name = chain.rawValue
            info.decimals = chain.decimal
            info.symbol = chain.symbol
            pool[info.id] = info
        }
    }
    
    func add(info: CoinInfo) {
//        if pool.keys.contains(info.id) {
//        }
        pool[info.id] = info
    }
    
    func fetchingCoin(coin: Coin) -> Promise<CoinInfo> {
        
        return Promise<CoinInfo> { seal in
            
            if pool.keys.contains(coin.id) {
                seal.fulfill(pool[coin.id]!)
                return
            }
            
            // TODO
            
        }
    }
    
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

extension CoinInfoHelper {
    
    func loadFromCache() {
        
    }
    
    func storeInCache() {
        
    }

    
}
