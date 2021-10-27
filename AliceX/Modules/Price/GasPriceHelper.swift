//
//  GasPriceHelper.swift
//  AliceX
//
//  Created by lmcmz on 19/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import BigInt
import Foundation
import PromiseKit
import web3swift

enum GasPrice {
    case fast
    case average
    case slow
    case custom(BigUInt)

    // TODO: FIX Custom

    // GWei
    var price: Float {
        switch self {
        case .fast:
            return GasPriceHelper.shared.fast ?? 10
        case .average:
            return GasPriceHelper.shared.average ?? 3
        case .slow:
            return GasPriceHelper.shared.safeLow ?? 1
        case let .custom(wei):
            guard let str = Web3.Utils.formatToEthereumUnits(wei, toUnits: .Gwei, decimals: 18, decimalSeparator: ".") else {
                return GasPriceHelper.shared.average ?? 3
            }
            return Float(str)!
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
        case .custom:
            return GasPriceHelper.shared.avgWait ?? 3
        }
    }

    var wei: BigUInt {
        // GWei to wei 9
        switch self {
        case .fast, .average, .slow:
            let wei = self.price * pow(10, 9)
            return BigUInt(wei)
        case let .custom(wei):
            return wei
        }
    }

    var timeString: String {
        return "~ \(self.time) mins"
    }

    var option: String {
        switch self {
        case .fast:
            return "fast"
        case .slow:
            return "slow"
        case .average:
            return "average"
        case let .custom(gas):
            return String(gas, radix: 16)
        }
    }

    static func make(string: String) -> GasPrice? {
        switch string {
        case "fast":
            return GasPrice.fast
        case "slow":
            return GasPrice.slow
        case "average":
            return GasPrice.average
        default:
            if let gasPrice = BigUInt(string.stripHexPrefix(), radix: 16) {
                return .custom(gasPrice)
            }
            return nil
        }
    }

    func toEth(gasLimit: BigUInt) -> Float {
        return gasLimit.gweiToEth * self.price
    }

    func toEthString(gasLimit: BigUInt) -> String {
        return toEth(gasLimit: gasLimit).toString(decimal: 6)
    }

    func toCurrency(gasLimit: BigUInt) -> Float {
        return toEth(gasLimit: gasLimit) * PriceHelper.shared.exchangeRate
    }

    func toCurrencyString(gasLimit: BigUInt) -> String {
        return "\(toCurrency(gasLimit: gasLimit).rounded(toPlaces: 3))"
    }

    func toCurrencyFullString(gasLimit: BigUInt) -> String {
        let currency = PriceHelper.shared.currentCurrency
        return "\(currency.rawValue) \(currency.symbol) \(toCurrencyString(gasLimit: gasLimit))"
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
        return Promise { seal in firstly { () -> Promise<EthGasStationModel> in
            API(EthGasStation.gas)
        }.done { model in
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
