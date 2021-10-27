//
//  BigInt.swift
//  AliceX
//
//  Created by lmcmz on 19/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import BigInt
import web3swift

extension BigInt {
    var eth: Float {
        let ethValue = Web3.Utils.formatToEthereumUnits(BigUInt(self),
                                                        toUnits: .eth,
                                                        decimals: 6,
                                                        decimalSeparator: ".")
        return Float(ethValue!) as! Float
    }

    var currency: Float {
        return eth * PriceHelper.shared.exchangeRate
    }
}

extension BigUInt {
    var gweiToEth: Float {
        // Gwei 9  Eth 18
        let ethValue = Web3.Utils.formatToEthereumUnits(self,
                                                        toUnits: .Gwei,
                                                        decimals: 6,
                                                        decimalSeparator: ".")
        return Float(ethValue!)!
    }

    var currency: Float {
        return (gweiToEth * PriceHelper.shared.exchangeRate).rounded(toPlaces: 3)
    }

    var currencyLabel: String {
        let currency = PriceHelper.shared.currentCurrency
        return "\(currency.rawValue) \(currency.symbol) \(self.currency)"
    }

    var readableValue: String {
        let string = Web3Utils.formatToEthereumUnits(self, toUnits: .eth, decimals: 5, decimalSeparator: ".")!
        return String.removeTrailingZero(string: string)
    }

    func readableValue(decimals: Int) -> String {
        guard let string = Web3Utils.formatToPrecision(self, numberDecimals: decimals, formattingDecimals: 5, decimalSeparator: ".", fallbackToScientific: false) else {
            return ""
        }
        //            .formatToEthereumUnits(self, toUnits: .eth, decimals: 5, decimalSeparator: ".")!
        return String.removeTrailingZero(string: string)
    }

    func formatToPrecision(decimals: Int, removeZero: Bool = true, scientific: Bool = false) -> String? {
        guard let string = Web3.Utils.formatToPrecision(self, numberDecimals: decimals, formattingDecimals: decimals, decimalSeparator: ".", fallbackToScientific: scientific),
              let amountInDouble = Double(string) else {
            return nil
        }

        if removeZero {
            return String(format: "%g", amountInDouble)
        }

        return String(amountInDouble)
    }
}
