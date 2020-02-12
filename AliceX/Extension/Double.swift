//
//  Double.swift
//  AliceX
//
//  Created by lmcmz on 12/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }

    func toString(decimal: Int = 9) -> String {
        let value = decimal < 0 ? 0 : decimal
        var string = String(format: "%.\(value)f", self)

        while string.last == "0" || string.last == "." {
            if string.last == "." { string = String(string.dropLast()); break }
            string = String(string.dropLast())
        }
        return string
    }

    var currencyString: String {
        let currency = PriceHelper.shared.currentCurrency
        return "\(currency.rawValue) \(currency.symbol) \(rounded(toPlaces: 3))"
    }

    func removeZerosFromEnd() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = (String(self).components(separatedBy: ".").last)!.count + 1
        return String(formatter.string(from: number) ?? "")
    }

    var clean: String {
        return truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

extension Decimal {
    var doubleValue:Double {
        return NSDecimalNumber(decimal:self).doubleValue
    }
}

extension Float {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places: Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }

    var currency: Float {
        return self * PriceHelper.shared.exchangeRate
    }

    var currencyString: String {
        let currency = PriceHelper.shared.currentCurrency
        return "\(currency.rawValue) \(currency.symbol) \(rounded(toPlaces: 3))"
    }

    func toString(decimal: Int = 9) -> String {
        let value = decimal < 0 ? 0 : decimal
        var string = String(format: "%.\(value)f", self)

        while string.last == "0" || string.last == "." {
            if string.last == "." { string = String(string.dropLast()); break }
            string = String(string.dropLast())
        }
        return string
    }
}
