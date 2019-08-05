//
//  WalletManager+Network.swift
//  AliceX
//
//  Created by lmcmz on 3/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import web3swift
import HandyJSON

struct Web3NetModel: HandyJSON {
    var name: String!
    var chainID: Int!
    var color: String!
    var rpcURL: String!
}

private let web3NetStoreKey = "alice.web3.net"

enum Web3NetEnum: String, CaseIterable {
    case main
    case ropsten
    case kovan
    case rinkeby
    case goerli
    case poa
//    case xDai
    case custom
}

extension Web3NetEnum {
    var color: UIColor {
        switch self {
        case .main:
            return UIColor(hex: "#45A9A5")
        case .ropsten:
            return UIColor(hex: "#EF5081")
        case .kovan:
            return UIColor(hex: "#6746F9")
        case .rinkeby:
            return UIColor(hex: "#EDBF49")
        case .goerli:
            return UIColor(hex: "#4383DE")
        case .poa:
            return UIColor(hex: "#F19164")
        default:
            return UIColor.white
        }
    }

    var chainID: Int {
        switch self {
        case .main: return 1
        case .kovan: return 42
        case .ropsten: return 3
        case .rinkeby: return 4
        case .poa: return 99
//        case .xDai: return 100
        case .goerli: return 5
//        case .custom(let custom):
//            return custom.chainID
        // TODO: Custom
        case .custom: return -1
        }
    }

    var rpcURL: URL {
        let urlString: String = {
            switch self {
            case .main: return "https://mainnet.infura.io/v3/da3717f25f824cc1baa32d812386d93f"
            case .kovan: return "https://kovan.infura.io/v3/da3717f25f824cc1baa32d812386d93f"
            case .ropsten: return "https://ropsten.infura.io/v3/da3717f25f824cc1baa32d812386d93f"
            case .rinkeby: return "https://rinkeby.infura.io/v3/da3717f25f824cc1baa32d812386d93f"
            case .poa: return "https://core.poa.network"
            case .goerli: return "https://goerli.infura.io/v3/da3717f25f824cc1baa32d812386d93f"
//            case .xDai: return "https://dai.poa.network"
            case .custom: return ""
            }
        }()
        return URL(string: urlString)!
    }
    
    var model: Web3NetModel {
        return  Web3NetModel(name: self.rawValue,
                             chainID: self.chainID,
                             color: self.color.toHexString(),
                             rpcURL: self.rpcURL.absoluteString)
    }
}

class Web3Net {
    static var currentNetwork: Web3NetEnum = .main

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

    class func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }

    class func storeInCache(type: Web3NetEnum) {
        UserDefaults.standard.set(type.rawValue, forKey: web3NetStoreKey)
    }

    class func fetchFromCache() -> web3 {
        // Not find the key in UserDefault use MainNet
        if !Web3Net.isKeyPresentInUserDefaults(key: web3NetStoreKey) {
            Web3Net.storeInCache(type: .main)
            return Web3.InfuraMainnetWeb3()
        }

        guard let typeString = UserDefaults.standard.string(forKey: web3NetStoreKey),
            let type = Web3NetEnum(rawValue: typeString) else {
            // TODO:
            HUDManager.shared.showError(text: WalletError.netCacheFailure.errorDescription)
            return Web3.InfuraMainnetWeb3()
        }

        do {
            let net = try Web3Net.make(type: type)
            Web3Net.currentNetwork = type
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


