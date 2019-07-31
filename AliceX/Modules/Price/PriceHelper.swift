//
//  PriceHelper.swift
//  AliceX
//
//  Created by lmcmz on 18/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import PromiseKit

private let AliceCurrencyKey = "alice.currency.key"
//private let AliceCurrencyResponseKey = "alice.currency.key"

class PriceHelper {
    
    static let shared = PriceHelper()
    
    var currentCoin: CryptoCoin = .ETH
    var currentCurrency: Currency = .USD
    var exchangeRate: Float = 0
    var updateDate: Date?
    var reponse: CoinMarketCapCurrencyModel?
    
    func changeCurrency(currency: Currency) {
        self.getExchangePrice(currency: currency) {
            self.currentCurrency = currency
            self.exchangeRate = self.reponse!.price!
            self.updateDate = self.reponse!.last_updated!
            self.storeInUserDefault()
            HUDManager.shared.showSuccess(text: "Switch currency success")
            self.postNotification()
        }
    }
    
    func storeInUserDefault() {
         UserDefaults.standard.set(self.reponse?.toJSONString(), forKey: AliceCurrencyKey)
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.string(forKey: key) != nil
    }
    
    func fetchFromCache() {
        if isKeyPresentInUserDefaults(key: AliceCurrencyKey) {
            let typeString = UserDefaults.standard.string(forKey: AliceCurrencyKey)
            let currencyModel = CoinMarketCapCurrencyModel.deserialize(from: typeString)
            reponse = currencyModel
            currentCurrency = (currencyModel?.currency)!
            exchangeRate = currencyModel!.price!
            updateDate = currencyModel!.last_updated!
            getExchangePrice(currency: currentCurrency, callback: nil)
            return
        }
        
        getExchangePrice(currency: .USD, callback: nil)
    }
    
    // TODO MORE THAN SUPPORT ETH
    func getExchangePrice(currency: Currency, callback: VoidBlock) {
//        coinMarketCapAPI.request(.latest(currency: currency)) { (result) in
//
//            switch result {
//            case let .success(response):
//                let model = response.mapObject(CoinMarketCapModel.self)
//                let quote =  model?.data?.first?.quote?.toJSON()
//                let price = quote![currency.rawValue] as! [String: Any]
//                var currencyModel = CoinMarketCapCurrencyModel.deserialize(from: price)
//                currencyModel?.currency = currency
//                self.reponse = currencyModel
//                self.currentCurrency = (currencyModel?.currency)!
//                self.exchangeRate = currencyModel!.price!
//                self.updateDate = currencyModel!.last_updated!
//                guard let block = callback else {
//                    return
//                }
//                block()
//            case let .failure(_):
//                HUDManager.shared.showError(text: "Fetch currency fail")
//            }
//        }
    }
    
    func getTokenInfo(tokenAdress: String) -> Promise<TokenInfo> {
        return Promise{ seal in firstly { () -> Promise<TokenInfo> in
            return API(Ethplorer.getTokenInfo(address: tokenAdress))
        }.done { (model) in
            seal.fulfill(model)
        }.catch({ (error) in
            seal.reject(error)
        })
        }
    }
    
    func postNotification() {
        NotificationCenter.default.post(name: .currencyChange, object: nil)
    }
}
