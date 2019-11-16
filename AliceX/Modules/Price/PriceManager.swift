//
//  PriceManager.swift
//  AliceX
//
//  Created by lmcmz on 4/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import PromiseKit
//import RxSwift

class PriceManager {
    static let shared = PriceManager()
    var currentCurrency: Currency = .USD
    
    var price: [String: CryptocompareModel]! = [:]
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateWatchingList), name: .currencyChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func updateWatchingList() {
//        getCoinsPrice(coins: WatchingCoinHelper.shared.list)
    }
    
    func getCoinsPrice(coins: [Coin], currency: Currency = PriceHelper.shared.currentCurrency) -> Promise<Void> {
    
        return Promise<Void> { seal in
            
            var symbols: [String] = []
            var pickedCoin: [Coin] = []
            for coin in coins {
                if let info = coin.info {
                    symbols.append(info.symbol)
                    pickedCoin.append(coin)
                }
            }
            
            CryptocompareAPI.request(.fullPrice(symbol: symbols, currency: currency)) { result in
                switch result {
                case .success(let reponse):
                    
                    guard let dataString = String(data: reponse.data, encoding: .utf8) else {
                        return
                    }
                    
                    for coin in pickedCoin {
                        if let model = CryptocompareModel.deserialize(from: dataString, designatedPath: "RAW.\(coin.info!.symbol!).\(currency.rawValue)") {
                            self.price[coin.id] = model
                            
                            if let info = CoinInfoCenter.shared.pool[coin.id] {
                                CoinInfoCenter.shared.pool[coin.id]?.price = model.PRICE
                                CoinInfoCenter.shared.pool[coin.id]?.changeIn24H = model.CHANGE24HOUR
                            }
                        }
                    }
                    CoinInfoCenter.shared.storeInCache()
                    seal.fulfill(())
                case .failure(let error):
                    print(error)
                    seal.reject(error)
                }
            }
            
        }
    }
    
    func getCoinsPriceWithPromise(coins: [CoinInfo], currency: Currency = PriceManager.shared.currentCurrency) -> Promise<[CryptocompareModel]> {
        
        return Promise<[CryptocompareModel]> { seal in
            
//            let priceList = []
            let symbols = coins.compactMap { $0.symbol }
            CryptocompareAPI.request(.fullPrice(symbol: symbols, currency: currency)) { result in
                switch result {
                case .success(let reponse):
                    
                    guard let dataString = String(data: reponse.data, encoding: .utf8) else {
                        seal.reject(MyError.DecodeFailed)
                        return
                    }
                    
                    var priceList: [CryptocompareModel] = []
                    for coin in coins {
                        if let model = CryptocompareModel.deserialize(from: dataString, designatedPath: "RAW.\(coin.symbol).\(currency.rawValue)") {
                            self.price[coin.id] = model
                            priceList.append(model)
                        }
                    }
                    CoinInfoCenter.shared.storeInCache()
                    seal.fulfill(priceList)
                case .failure(let error):
                    print(error)
                    seal.reject(error)
                }
            }

        }
        
    }
    
    
}
