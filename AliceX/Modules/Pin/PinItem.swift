//
//  PinItem.swift
//  AliceX
//
//  Created by lmcmz on 2/9/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation

enum PinItem {
    case website(image: UIImage, url: URL, title: String)
    case dapplet(image: UIImage, url: URL, title: String)
    case transaction(network: Web3NetEnum, txHash: String, title: String)
    
    var txHash: String {
        switch self {
        case .transaction(_, let txHash, _):
            return txHash
        default:
            return ""
        }
    }
    
    var network: Web3NetEnum {
        switch self {
        case .transaction(let network, _, _):
            return network
        default:
            return .main
        }
    }
    
    var URL: URL? {
        switch self {
        case .transaction(let network, let txHash, _):
            if !network.isUsingInfura {
                return network.rpcURL
            }
            if network == .main {
//                return URL(string: "https://etherscan.io/tx/\(txHash)")
                return Foundation.URL(string: "https://etherscan.io/tx/\(txHash)")
            }
            return Foundation.URL(string: "https://\(network.name).etherscan.io/tx/\(txHash)")
        case .dapplet(_, let url, _):
            return url
        case .website(_, let url, _):
            return url
        }
    }
}

extension PinItem: Hashable {
    var hashValue: Int {
        switch self {
        case .website(_, let url, _):
            return url.absoluteString.hashValue
        case .dapplet(_, let url, _):
            return url.absoluteString.hashValue
        case .transaction(_, let txHash, _):
            return txHash.hashValue
        }
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .website(_, let url, _):
            hasher.combine(url)
        case .dapplet(_, let url, _):
            hasher.combine(url)
        case .transaction(_, let txHash, _):
            hasher.combine(txHash)
        }
    }
}
