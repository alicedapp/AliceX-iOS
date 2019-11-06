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
                updateTokens()
            }.then { _ in
                PriceManager.shared.getCoinsPrice(coins: self.list)
            }.done { () in
                self.sortByPrice()
                seal.fulfill(())
            }.catch { error in
                seal.reject(error)
            }
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
                    
                    CoinInfoHelper.shared.add(info: info)
                    
                    let coin = Coin.ERC20(address: record.address)
                    
                    if record.name.isEmptyAfterTrim() && record.symbol.isEmptyAfterTrim() {
                        UnWatchingCoinHelper.shared.add(coin: coin)
                    } else {
                        self.add(coin: coin)
                    }
                    
                    return info
                }
                
                seal.fulfill(infoList)
            }.catch { error in
                seal.reject(error)
            }
        }
    }
    
}
