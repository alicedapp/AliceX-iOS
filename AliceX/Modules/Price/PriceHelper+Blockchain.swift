//
//  PriceHelper+Blockchain.swift
//  AliceX
//
//  Created by lmcmz on 2/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import Haneke

extension PriceHelper {
    func getBlockchainCoinPrice(currency: Currency, callback _: VoidBlock) {
        coinMarketCapAPI.request(.quote(currency: currency)) { result in
            switch result {
            case let .success(response):
                for chain in BlockChain.allCases {
                    let id = String(chain.coinMaeketCapID)
                    if let model = response.mapObject(CoinMarketCapDataModel.self,
                                                      designatedPath: "data.\(id)") {
                        self.chainData[id] = model
                    }
                }
                self.postPriceNotification()
            case let .failure(error):
                print("error: \(error)")
            }
        }
    }

    func getChainData(chain: BlockChain) -> CoinMarketCapDataModel? {
        let id = String(chain.coinMaeketCapID)
        if !chainData.keys.contains(id) {
            return nil
        }

        return chainData[id]!
    }

//    func getChainPric

    func postPriceNotification() {
        NotificationCenter.default.post(name: .priceUpdate, object: nil)
    }

    func loadBlockchainCache() {
        Shared.stringCache.fetch(key: CacheKey.blockchainKey).onSuccess { _ in
        }
    }
}
