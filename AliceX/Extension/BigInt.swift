//
//  BigInt.swift
//  AliceX
//
//  Created by lmcmz on 19/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import web3swift
import BigInt

extension BigInt {
    var eth: Float {
        let ethValue = Web3.Utils.formatToEthereumUnits(BigUInt(self),
                                                        toUnits: .eth,
                                                        decimals: 6,
                                                        decimalSeparator: ".")
        return Float(ethValue!) as! Float
    }
    
    var currency: Float {
        return self.eth * PriceHelper.shared.exchangeRate
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
        return (self.gweiToEth * PriceHelper.shared.exchangeRate).rounded(toPlaces: 3)
    }
    
    var currencyLabel: String {
        let currency = PriceHelper.shared.currentCurrency
        return "\(currency.rawValue) \(currency.symbol) \(self.currency)"
    }
    
    var readableValue: String {
        return Web3Utils.formatToEthereumUnits(self, toUnits: .eth, decimals: 5, decimalSeparator: ".")!
    }
}
