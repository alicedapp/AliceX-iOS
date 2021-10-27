//
//  WalletManager+CustomRPC.swift
//  AliceX
//
//  Created by lmcmz on 12/9/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import Haneke

extension WalletManager {
    func addRPC(model: Web3NetModel) {
        WalletManager.customNetworkList.append(model)
        //        let modelList = WalletManager.customNetworkList.map{
        //            $0.model
        //        }
        storeRPCToCache()
    }

    func updateRPC(oldModel: Web3NetModel, newModel: Web3NetModel) {
        guard let index = WalletManager.customNetworkList.firstIndex(of: oldModel) else {
            return
        }
        WalletManager.customNetworkList[index] = newModel

        if WalletManager.currentNetwork.model == oldModel {
            WalletManager.currentNetwork = Web3NetEnum(model: newModel)
        }

        storeRPCToCache()
    }

    func deleteRPC(model: Web3NetModel) {
        guard let index = WalletManager.customNetworkList.firstIndex(of: model) else {
            return
        }
        WalletManager.customNetworkList.remove(at: index)

        if WalletManager.currentNetwork.model == model {
            WalletManager.currentNetwork = .main
        }

        storeRPCToCache()
    }

    func loadRPCFromCache() {
        Shared.stringCache.fetch(key: CacheKey.web3CustomRPCKey).onSuccess { string in
            guard let list = Web3NetModelList.deserialize(from: string) else {
                HUDManager.shared.showError(text: "Load Custom PRC faild")
                return
            }
            WalletManager.customNetworkList = list.list
        }
    }

    func storeRPCToCache() {
        let list = Web3NetModelList(list: WalletManager.customNetworkList)
        guard let listString = list.toJSONString() else {
            return
        }
        Shared.stringCache.set(value: listString, key: CacheKey.web3CustomRPCKey)
        NotificationCenter.default.post(name: .customRPCChange, object: nil)
    }

    func removeAllRPC() {
        WalletManager.customNetworkList = []
        Shared.stringCache.remove(key: CacheKey.web3CustomRPCKey)
    }
}
