//
//  Blockchain.swift
//  AliceX
//
//  Created by lmcmz on 28/10/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import web3swift
import WalletCore

enum BlockChain: String, CaseIterable {
    case Ethereum
    case Bitcoin
    case Binance
//    case Cosmos
//    case unknow
}

extension BlockChain {
    var coinMaeketCapID: Int {
        switch self {
        case .Ethereum:
            return 1027
        case .Binance:
            return 1839
        case .Bitcoin:
            return 1
//        case .Cosmos:
//            return 3794
        }
    }

    var data: CoinMarketCapDataModel? {
        return PriceHelper.shared.getChainData(chain: self)
    }

    var image: String {
        return Coin.coin(chain: self).image.absoluteString
    }

//    var price: Double {
//        PriceHelper.shared
//    }

    var coinType: CoinType {
        switch self {
        case .Ethereum:
            return .ethereum
        case .Binance:
            return .binance
        case .Bitcoin:
            return .bitcoin
//        case .Cosmos:
//            return .cosmos
        }
    }

    var symbol: String {
        switch self {
        case .Ethereum:
            return "ETH"
        case .Binance:
            return "BNB"
        case .Bitcoin:
            return "BTC"
//        case .Cosmos:
//            return "ATOM"
        }
    }

    var amberDataID: String {
        switch self {
        case .Ethereum:
            return "1c9c969065fcd1cf"
        case .Bitcoin:
            return "408fa195a34b533de9ad9889f076045e"
        case .Binance:
            return "none"
        default:
            return "1c9c969065fcd1cf"
        }
    }

    var decimal: Int {
        switch self {
        case .Bitcoin, .Binance:
            return 8
        case .Ethereum:
            return 18
//        case .Cosmos:
//            return 9
        }
    }

    var explorer: URL {
        switch self {
        case .Ethereum:
            return URL(string: "https://etherscan.io")!
        case .Binance:
            return URL(string: "https://explorer.binance.org")!
//        case .Cosmos:
//            return URL(string: "https://www.mintscan.io")!
        case .Bitcoin:
            return URL(string: "https://btc.com")!
        }
    }

    var basicInfo: TokenInfo {
        var info = TokenInfo()
        info.decimals = decimal
        info.symbol = symbol
        switch self {
        case .Ethereum:
            info.decimals = decimal
            info.name = "Ethereum"
            info.symbol = symbol
            info.description = "Ethereum is an open source, public, blockchain-based distributed computing platform and operating system featuring smart contract (scripting) functionality. It supports a modified version of Nakamoto consensus via transaction-based state transitions."
        case .Bitcoin:
            info.name = "Bitcoin"
            info.description = "Bitcoin (₿) is a cryptocurrency. It is a decentralized digital currency without a central bank or single administrator that can be sent from user to user on the peer-to-peer bitcoin network without the need for intermediaries"
        case .Binance:
            info.name = "Binance Coin"
            info.description = "Binance coin is a digital currency issued by the cryptocurrency exchange Binance. The cryptocurrency is denoted by the symbol BNB. It is based on the Ethereum blockchain and similar to Ether, the BNB token also fuels all operations on Binance.com."
        }
        return info
    }

    func txURL(txHash: String, network: Web3NetEnum? = WalletManager.currentNetwork) -> URL {
        switch self {
        case .Ethereum:
            return PinItem.txURL(network: network ?? WalletManager.currentNetwork, txHash: txHash)
        case .Binance:
            return URL(string: "https://explorer.binance.org/tx/\(txHash)")!
//        case .Cosmos:
//            return URL(string: "https://www.mintscan.io/txs/\(txHash)")!
        case .Bitcoin:
            return URL(string: "https://btc.com/\(txHash)")!
        }
    }

    func verify(address: String) -> Bool {
        switch self {
        case .Ethereum:
            guard let addr = web3swift.EthereumAddress(address), addr.isValid else {
                return false
            }
            return true
        case .Binance, .Bitcoin:
            return self.coinType.validate(address: address)

//        case .Cosmos:
//            return self.coinType.validate(address: address)
        }
    }
}
