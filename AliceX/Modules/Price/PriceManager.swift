//
//  PriceManager.swift
//  AliceX
//
//  Created by lmcmz on 4/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import PromiseKit
import RxSwift

class PriceManager {
    static let shared = PriceManager()
    var currentCurrency: Currency = .USD
    
    var price: [String: CryptocompareModel]!
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateWatchingList), name: .currencyChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func updateWatchingList() {
        getCoinsPrice(coins: WatchingCoinHelper.shared.list)
    }
    
    func getCoinsPrice(coins: [Coin], currency: Currency = PriceManager.shared.currentCurrency) {
    
        let symbols = coins.compactMap { $0.symbol }
        CryptocompareAPI.request(.fullPrice(symbol: symbols, currency: currency)) { result in
            switch result {
            case .success(let reponse):
                
                guard let dataString = String(data: reponse.data, encoding: .utf8) else {
                    return
                }
                
                for symbol in symbols {
                    if let model = CryptocompareModel.deserialize(from: dataString, designatedPath: "Raw.\(symbol).\(currency.rawValue)") {
                        self.price[symbol] = model
                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
