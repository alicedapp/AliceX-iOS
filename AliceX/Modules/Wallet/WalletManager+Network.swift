//
//  WalletManager+Network.swift
//  AliceX
//
//  Created by lmcmz on 3/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import BigInt
import Foundation
import HandyJSON
import web3swift

struct Web3NetModel: HandyJSON, Equatable{
    var name: String!
    var chainID: Int!
    var color: String!
    var rpcURL: String!
    
//    static func == (lhs: Web3NetEnum, rhs: Web3NetEnum) -> Bool {
//        return lhs.chainID == rhs.chainID && lhs.rpcURL == rhs.rpcURL
//    }
}

struct Web3NetModelList: HandyJSON {
    var list: [Web3NetModel]!
}

enum Web3NetEnum: CaseIterable, Equatable {
    case main
    case ropsten
    case kovan
    case rinkeby
    case goerli
    case poa
    case xDai
    case custom(Web3NetModel)
    
    init(model: Web3NetModel) {
        switch model {
        case Web3NetEnum.main.model:
            self = Web3NetEnum.main
        case Web3NetEnum.ropsten.model:
            self = Web3NetEnum.ropsten
        case Web3NetEnum.kovan.model:
            self = Web3NetEnum.kovan
        case Web3NetEnum.rinkeby.model:
            self = Web3NetEnum.rinkeby
        case Web3NetEnum.goerli.model:
            self = Web3NetEnum.goerli
        case Web3NetEnum.poa.model:
            self = Web3NetEnum.poa
        case Web3NetEnum.xDai.model:
            self = Web3NetEnum.xDai
        default: // Custom
            self = Web3NetEnum.custom(model)
        }
    }
    
    static var allCases: [Web3NetEnum] {
        let defaultList: [Web3NetEnum] = [.main, .ropsten, .kovan, .rinkeby, .goerli, .poa, .xDai]
        let customList = WalletManager.customNetworkList.map{
            Web3NetEnum(model: $0)
        }
        return defaultList + customList
    }
    
    static func == (lhs: Web3NetEnum, rhs: Web3NetEnum) -> Bool {
        return lhs.chainID == rhs.chainID && lhs.rpcURL == rhs.rpcURL && lhs.name == rhs.name
    }
}

extension Web3NetEnum {
    
    var name: String {
        switch self {
        case .main:
            return "Main"
        case .ropsten:
            return "Ropsten"
        case .kovan:
            return "Kovan"
        case .rinkeby:
            return "Rinkeby"
        case .goerli:
            return "Goerli"
        case .poa:
            return "Poa"
        case .xDai:
            return "xDai"
        case .custom(let model):
            return model.name
        default:
            return "Custom"
        }
    }
    
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
        case .xDai:
            return UIColor(hex: "#98CEED")
        case .custom(let model):
            return UIColor(hex: model.color)
        default:
            return UIColor.lightGray
        }
    }

    var chainID: Int {
        switch self {
        case .main: return 1
        case .kovan: return 42
        case .ropsten: return 3
        case .rinkeby: return 4
        case .poa: return 99
        case .xDai: return 100
        case .goerli: return 5
//        case .custom(let chainID): return chainID
        case .custom(let model):
            return model.chainID
        }
    }

    var rpcURL: URL {
        let urlString: String = {
            switch self {
            case .main: return "https://mainnet.infura.io/v3/\(Constant.infuraKey)"
            case .kovan: return "https://kovan.infura.io/v3/\(Constant.infuraKey)"
            case .ropsten: return "https://ropsten.infura.io/v3/\(Constant.infuraKey)"
            case .rinkeby: return "https://rinkeby.infura.io/v3/\(Constant.infuraKey)"
            case .poa: return "https://core.poa.network"
            case .goerli: return "https://goerli.infura.io/v3/\(Constant.infuraKey)"
            case .xDai: return "https://dai.poa.network"
            case .custom(let model):
                return model.rpcURL
            }
        }()
        return URL(string: urlString)!
    }
    
    var isUsingInfura: Bool {
        switch self {
        case .main, .ropsten, .kovan, .rinkeby, .goerli:
            return true
        default:
            return false
        }
    }
    
    var isCustom: Bool {
        switch self {
        case .main, .ropsten, .kovan, .rinkeby, .goerli, .poa, .xDai:
            return false
        default:
            return true
        }
    }

    var model: Web3NetModel {
        return Web3NetModel(name: name,
                            chainID: chainID,
                            color: color.toHexString(),
                            rpcURL: rpcURL.absoluteString)
    }

    var network: Networks {
        switch self {
        case .main: return .Mainnet
        case .rinkeby: return .Rinkeby
        case .ropsten: return .Ropsten
        case .kovan: return .Kovan
        case .goerli: return .Custom(networkID: 5)
        case .poa: return .Custom(networkID: 99)
        case .xDai: return .Custom(networkID: 100)
        case .custom(let model):
            return .Custom(networkID: BigUInt(model.chainID))
//        case .custom(let chainID): return .Custom(networkID: chainID)
        }
    }
    
}

extension WalletManager {

    class func make(type: Web3NetEnum, customURL _: String = "https://mainnet.infura.io/v3/") throws -> web3 {
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
        case .xDai, .poa, .custom:
            do {
                let net = try WalletManager.customNet(url: type.rpcURL.absoluteString)
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

    class func storeInCache(type: Web3NetModel) {
        UserDefaults.standard.set(type.toJSONString(), forKey: CacheKey.web3NetStoreKey)
    }

    class func fetchFromCache() -> web3 {
        UserDefaults.standard.removeObject(forKey: "alice.web3.net")
        // Not find the key in UserDefault use MainNet
        if !WalletManager.isKeyPresentInUserDefaults(key: CacheKey.web3NetStoreKey) {
            let net = Web3NetEnum.main
            WalletManager.storeInCache(type: net.model)
            return Web3.InfuraMainnetWeb3()
        }

        guard let typeString = UserDefaults.standard.string(forKey: CacheKey.web3NetStoreKey),
            let model = Web3NetModel.deserialize(from: typeString) else {
            // TODO:
            HUDManager.shared.showError(text: WalletError.netCacheFailure.errorDescription)
            return Web3.InfuraMainnetWeb3()
        }
        
        let type = Web3NetEnum(model: model)

        do {
            let net = try WalletManager.make(type: type)
            WalletManager.currentNetwork = type
            return net
        } catch let error as WalletError {
            HUDManager.shared.showError(text: error.errorDescription)
        } catch {
            HUDManager.shared.showError()
        }

        return Web3.InfuraMainnetWeb3()
    }

    class func fetchFromCache() -> String {
        guard let typeString = UserDefaults.standard.string(forKey: CacheKey.web3NetStoreKey),
            let model = Web3NetModel.deserialize(from: typeString) else {
            HUDManager.shared.showError(text: WalletError.netCacheFailure.errorDescription)
            return "Main"
        }
        let type = Web3NetEnum(model: model)
        return type.name
    }

    class func fetchFromCache() -> Web3NetEnum {
        guard let typeString = UserDefaults.standard.string(forKey: CacheKey.web3NetStoreKey),
            let model = Web3NetModel.deserialize(from: typeString) else {
            HUDManager.shared.showError(text: WalletError.netCacheFailure.errorDescription)
            return .main
        }
        
        let type = Web3NetEnum(model: model)
        return type
    }

    // MARK: - Update

    class func updateNetworkSelection(type: Web3NetEnum) {
        WalletManager.updateNetwork(type: type)
    }
}
