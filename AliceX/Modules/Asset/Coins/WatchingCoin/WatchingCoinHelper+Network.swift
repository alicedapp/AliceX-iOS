//
//  WatchingCoinHelper+Network.swift
//  AliceX
//
//  Created by lmcmz on 6/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import PromiseKit

extension WatchingCoinHelper {
    
    func update() -> Promise<Void> {
        return Promise<Void> { seal in
            firstly{
                when(fulfilled: updateTokens(), updateCoins())
            }.then { _ in
                PriceManager.shared.getCoinsPrice(coins: self.list)
            }.done { () in
                if self.noCache { // Sort by price frist time
                    self.sortByPrice()
                }
                seal.fulfill(())
            }.catch { error in
                seal.reject(error)
            }
        }
    }
    
    func updateCoins() -> Promise<Void> {
        return Promise<Void> { seal in
            
            blockchainList().forEach { chain in
    //            let coin = Coin.coin(chain: chain)
                var info = CoinInfo()
                info.id = chain.rawValue
                info.name = chain.rawValue
                info.decimals = chain.decimal
                info.symbol = chain.symbol
                CoinInfoHelper.shared.add(info: info)

                chain.getBalance().done { balance in
                    info.amount = String(balance)
                    CoinInfoHelper.shared.pool[info.id] = info
                }
            }
            
//            CoinInfoHelper.shared.storeInCache()
            seal.fulfill(())
            
        }
    }
    
    func updateTokens() -> Promise<[CoinInfo]> {
        return Promise<[CoinInfo]> { seal in
            firstly{ () -> Promise<AmberdataTokenList> in
                // TODO
                API(AmberData.tokens(address: "0xa1b02d8c67b0fdcf4e379855868deb470e169cfb"), path: "payload")
            }.done { model in
                
                guard let records = model.records, records.count > 0 else {
                    return
                }
                
                let infoList = records.filter{ $0.isERC20 == true }.flatMap { record -> CoinInfo? in
                    
                    var info = CoinInfo()
                    info.symbol = record.symbol
                    info.decimals = record.decimals
                    info.name = record.name
                    info.id = record.address
                    info.amount = record.amount
                    
                    CoinInfoHelper.shared.update(newInfo: info)
                    
                    let coin = Coin.ERC20(address: record.address)
                    
                    if record.name.isEmptyAfterTrim() && record.symbol.isEmptyAfterTrim() {
                        IgnoreCoinHelper.shared.add(coin: coin)
                    } else {
                        self.add(coin: coin)
                    }
                    
                    return info
                }
                
                CoinInfoHelper.shared.storeInCache()
                
                seal.fulfill(infoList)
            }.catch { error in
                seal.reject(error)
            }
        }
    }
    
}
