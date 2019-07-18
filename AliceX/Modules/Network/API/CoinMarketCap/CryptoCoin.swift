//
//  CryptoCoin.swift
//  AliceX
//
//  Created by lmcmz on 19/6/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation

// https://coinmarketcap.com/api/documentation/v1/#section/Standards-and-Conventions
enum Currency: String, CaseIterable {
    case USD
    case EUR
    case CNY
    case AUD
    case CAD
    case KRW
    case HKD
    case SGD
    case RUB
    case JPY
    case TWD
    case CHF
    case MXN
    
    var symbol: String {
        switch self {
        case .USD:
            return "$"
        case .CNY:
            return "¥"
        case .AUD:
            return "$"
        case .EUR:
            return "€"
        case .CHF:
            return "Fr"
        case .KRW:
            return "₩"
        case .RUB:
            return "₽"
        case .JPY:
            return "¥"
        case .TWD:
            return "$"
        case .MXN:
            return "$"
        case .SGD:
            return "$"
        case .CAD:
            return "$"
        case .HKD:
            return "$"
        }
    }
    
    var name: String {
        switch self {
        case .USD:
            return "United States Dollar"
        case .EUR:
            return "Euro"
        case .CNY:
            return "Chinese Yuan"
        case .AUD:
            return "Australian Dollar "
        case .CHF:
            return "Swiss Franc"
        case .KRW:
            return "South Korean Won"
        case .SGD:
            return "Singapore Dollar"
        case .RUB:
            return "Russian Ruble"
        case .JPY:
            return "Japanese Yen"
        case .TWD:
            return "New Taiwan Dollar"
        case .MXN:
            return "Mexican Peso"
        case .CAD:
            return "Canadian Dollar"
        case .HKD:
            return "Hong Kong Dollar"
        }
    }
    
}

enum CryptoCoin {
    case ETH
    case BTC
}
