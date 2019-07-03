//
//  WalletManager+Network.swift
//  AliceX
//
//  Created by lmcmz on 3/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import web3swift

private let web3NetStoreKey = "alice.web3.net"

enum Web3NetEnum: String, CaseIterable {
    case main
    case rinkeby
    case ropsten
    case kovan
    case goerli
    case poa
    
    case custom
}

class Web3Net {
    
    static var currentNetwork: Web3NetEnum = Web3Net.fetchFromCache()
    
    class func make(type: Web3NetEnum, customURL: String = "https://mainnet.infura.io/v3/") throws -> web3 {
        switch type {
        case .main:
            return Web3.InfuraMainnetWeb3()
        case .ropsten:
            return Web3.InfuraRopstenWeb3()
        case .rinkeby:
            return Web3.InfuraRinkebyWeb3()
        case .kovan:
            return web3(provider: InfuraProvider(.Kovan)!)
        case .goerli:
            return web3(provider: InfuraProvider(.Custom(networkID: 5))!)
        case .poa:
            do {
                let net = try Web3Net.customNet(url: "https://core.poa.network")
                return net
            } catch {
                throw error
            }
        case .custom:
            do {
                let net = try Web3Net.customNet(url: customURL)
                return net
            } catch {
                throw error
            }
        }
        
//        return Web3.InfuraMainnetWeb3()
    }
    
    class func customNet(url: String) throws -> web3 {
        guard let URL = URL(string: url), let web3Url = Web3HttpProvider(URL) else {
            throw WalletError.netSwitchFailure
        }
        let net = web3(provider: web3Url)
        return net
    }
    
    // MARK: - Cache
    
    class func storeInCache(type: Web3NetEnum) {
        UserDefaults.standard.set(type.rawValue, forKey: web3NetStoreKey)
    }
    
    class func fetchFromCache() -> web3 {
        guard let typeString = UserDefaults.standard.string(forKey: web3NetStoreKey),
            let type = Web3NetEnum(rawValue: typeString) else {
            HUDManager.shared.showError(text: WalletError.netCacheFailure.errorDescription)
            return Web3.InfuraMainnetWeb3()
        }
        
        do {
            let net = try Web3Net.make(type: type)
            return net
        } catch let error as WalletError {
            HUDManager.shared.showError(text: error.errorDescription)
        } catch {
            HUDManager.shared.showError()
        }
        
        return Web3.InfuraMainnetWeb3()
    }
    
    class func fetchFromCache() -> String {
        guard let typeString = UserDefaults.standard.string(forKey: web3NetStoreKey),
            let type = Web3NetEnum(rawValue: typeString) else {
                HUDManager.shared.showError(text: WalletError.netCacheFailure.errorDescription)
                return "Main"
        }
        return typeString
    }
    
    class func fetchFromCache() -> Web3NetEnum {
        guard let typeString = UserDefaults.standard.string(forKey: web3NetStoreKey),
            let type = Web3NetEnum(rawValue: typeString) else {
                HUDManager.shared.showError(text: WalletError.netCacheFailure.errorDescription)
                return .main
        }
        return type
    }
    
    // MARK: - Update
    
    class func upodateNetworkSelection(type: Web3NetEnum) {
        WalletManager.updateNetwork(type: type)
    }
    
}
