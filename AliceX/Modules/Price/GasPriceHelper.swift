//
//  GasPriceHelper.swift
//  AliceX
//
//  Created by lmcmz on 19/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import BigInt
import PromiseKit
import web3swift

enum GasPrice: String, CaseIterable {
    case fast
    case average
    case slow
//    case custom(BigUInt)
    
    // GWei
    var price: Float {
        switch self {
        case .fast:
            return GasPriceHelper.shared.fast ?? 10
        case .average:
            return GasPriceHelper.shared.average ?? 3
        case .slow:
            return GasPriceHelper.shared.safeLow ?? 1
//        case .custom(let wei):
//            return wei.
        }
    }
    
    var time: Float {
        switch self {
        case .fast:
            return GasPriceHelper.shared.fastWait ?? 1
        case .average:
            return GasPriceHelper.shared.avgWait ?? 3
        case .slow:
            return GasPriceHelper.shared.safeLowWait ?? 10
        }
    }
    
    var wei: BigUInt {
        // TODO Not sure
        // GWei to wei 9
        let wei = self.price * pow(10, 8)
        return BigUInt(wei)
    }
    
    var timeString: String {
        return "~ \(self.time) mins"
    }
    
    func toEth(gasLimit: BigUInt) -> Float {
        return gasLimit.gweiToEth * self.price
    }
    
    func toEthString(gasLimit: BigUInt) -> String {
        return self.toEth(gasLimit: gasLimit).toString(decimal: 6)
    }
    
    func toCurrency(gasLimit: BigUInt) -> Float {
        return self.toEth(gasLimit: gasLimit) * PriceHelper.shared.exchangeRate
    }
    
    func toCurrencyString(gasLimit: BigUInt) -> String {
        return "\(self.toCurrency(gasLimit: gasLimit).rounded(toPlaces: 3))"
    }
    
    func toCurrencyFullString(gasLimit: BigUInt) -> String {
        let currency = PriceHelper.shared.currentCurrency
        return "\(currency.rawValue) \(currency.symbol) \(self.toCurrencyString(gasLimit: gasLimit))"
    }
}

class GasPriceHelper {
    
    static let shared = GasPriceHelper()
    var timeInterval: TimeInterval = 60 * 30
    
    var model: EthGasStationModel?
    
    var safeLow: Float?
    var average: Float?
    var fast: Float?
    
    // Minutes
    var safeLowWait: Float?
    var avgWait: Float?
    var fastWait: Float?
    

//    func getGasPrice() {
//        gasStationAPI.request(.gas) { (result) in
//            switch result {
//            case let .success(response):
//                guard let model = response.mapObject(EthGasStationModel.self) else {
//                    HUDManager.shared.showError(text: "Fetch gas station failed")
//                    return
//                }
//                self.model = model
//                self.update(model: model)
////                HUDManager.shared.showSuccess(text: "GET GAS")
//            case let .failure(error):
//                HUDManager.shared.showError(text: "Fech gas station failed")
//            }
//        }
//    }
    
    func getGasPrice() -> Promise<Void> {
        return Promise{ seal in firstly { () -> Promise<EthGasStationModel> in
                return API(EthGasStation.gas)
            }.done { (model) in
                self.model = model
                self.update(model: model)
                seal.fulfill(())
            }
        }
    }
    
    func update(model: EthGasStationModel) {
        safeLow = model.safeLow! / 10
        average = model.average! / 10
        fast = model.fast! / 10
        safeLowWait = model.safeLowWait
        avgWait = model.avgWait
        fastWait = model.fastWait
    }
}
