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
            firstly {
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
                chain.getBalance().done { balance in
//                    info.amount = String(balance)
                    guard let coin = CoinInfoCenter.shared.pool[chain.rawValue] else {
//                        seal.reject()
                        throw MyError.FoundNil("chain not found")
                    }
                    CoinInfoCenter.shared.pool[chain.rawValue]!.amount = String(balance)
                }
            }

//            CoinInfoCenter.shared.storeInCache()
            seal.fulfill(())
        }
    }

    func updateTokens() -> Promise<Bool> {
        return Promise<Bool> { seal in
            firstly { () -> Promise<AmberdataTokenList> in
                // TODO:
                API(AmberData.tokens(address: WalletManager.wallet!.address), path: "payload")
            }.done { model in

                if let records = model.records, records.count > 0 {
                    let infoList = records.filter { $0.isERC20 == true }.flatMap { record -> CoinInfo? in

                        var info = CoinInfo()
                        info.symbol = record.symbol
                        info.decimals = record.decimals
                        info.name = record.name
                        info.id = record.address
                        info.amount = record.amount

                        if !IgnoreCoinHelper.shared.list.contains(info.coin) {
                            CoinInfoCenter.shared.update(newInfo: info)

                            let coin = Coin.ERC20(address: record.address)
                            if record.name.isEmptyAfterTrim(), record.symbol.isEmptyAfterTrim() {
                                IgnoreCoinHelper.shared.add(coin: coin)
                            } else {
                                self.add(coin: coin, updateCache: true)
                            }
                            return info
                        }
                        return nil
                    }

                    CoinInfoCenter.shared.storeInCache()

                    seal.fulfill(true)
                } else {
                    seal.fulfill(true)
                    //                    throw MyError.FoundNil("ERC20 is empty")
                }

            }.catch { error in
                seal.reject(error)
            }
        }
    }
}
