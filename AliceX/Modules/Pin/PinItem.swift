//
//  PinItem.swift
//  AliceX
//
//  Created by lmcmz on 2/9/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation

protocol PinDelegate {
    func pinItem() -> PinItem
}

enum PinItem {
    case website(image: UIImage, url: URL, title: String, viewcontroller: UIViewController)
    case dapplet(image: UIImage, url: URL, title: String, viewcontroller: UIViewController)
    case transaction(network: Web3NetEnum, txHash: String, title: String, viewcontroller: UIViewController)
    
    var txHash: String {
        switch self {
        case .transaction(_, let txHash, _, _):
            return txHash
        default:
            return ""
        }
    }
    
    var network: Web3NetEnum {
        switch self {
        case .transaction(let network, _, _, _):
            return network
        default:
            return .main
        }
    }
    
    var URL: URL? {
        switch self {
        case .transaction(let network, let txHash, _, _):
            if !network.isUsingInfura {
                return network.rpcURL
            }
            if network == .main {
//                return URL(string: "https://etherscan.io/tx/\(txHash)")
                return Foundation.URL(string: "https://etherscan.io/tx/\(txHash)")
            }
            return Foundation.URL(string: "https://\(network.name).etherscan.io/tx/\(txHash)")
        case .dapplet(_, let url, _, _):
            return url
        case .website(_, let url, _, _):
            return url
        }
    }
    
    var vc: UIViewController {
        switch self {
        case .dapplet(_, _, _, let vc),
             .transaction(_, _, _, let vc),
             .website(_, _, _, let vc):
            return vc
        }
    }
    
    static func txURL(network: Web3NetEnum, txHash: String) -> URL {
        if !network.isUsingInfura {
            return network.rpcURL
        }
        if network == .main {
            //                return URL(string: "https://etherscan.io/tx/\(txHash)")
            return Foundation.URL(string: "https://etherscan.io/tx/\(txHash)")!
        }
        return Foundation.URL(string: "https://\(network.name).etherscan.io/tx/\(txHash)")!
    }
}

extension PinItem: Hashable {
    var hashValue: Int {
        switch self {
        case .website(_, let url, _, _):
            return url.absoluteString.hashValue
        case .dapplet(_, let url, _, _):
            return url.absoluteString.hashValue
        case .transaction(_, let txHash, _, _):
            return txHash.hashValue
        }
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .website(_, let url, _, _):
            hasher.combine(url)
        case .dapplet(_, let url, _, _):
            hasher.combine(url)
        case .transaction(_, let txHash, _, _):
            hasher.combine(txHash)
        }
    }
}
