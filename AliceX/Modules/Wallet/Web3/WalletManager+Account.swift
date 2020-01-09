//
//  WalletManager+Account.swift
//  AliceX
//
//  Created by lmcmz on 7/1/20.
//  Copyright © 2020 lmcmz. All rights reserved.
//

import Foundation
import web3swift
import Haneke
import PromiseKit
import SwiftyUserDefaults

extension WalletManager {
    
    // MARK: - Account
    
    class func storeAccountsToCache() {
        do {
            let data = try JSONEncoder().encode(WalletManager.Accounts!)
//            Shared.dataCache.set(value: data, key: IMPCacheKey.accountCacheKey)
            Defaults[\.accountsData] = data
            
        } catch {
            HUDManager.shared.showError(error: WalletError.createAccountFailure)
        }
    }
    
    class func fetchAccountsFromCache() -> Promise<[Account]> {
        
        return Promise<[Account]> { seal in
            
            guard let data = Defaults[\.accountsData] else {
                
                // Not first time open
                if Defaults[\.isFirstTimeOpen] == false {
                    let error = WalletError.custom("Decode accounts failed")
                    HUDManager.shared.showError(error: error)
                    seal.reject(error)
                }
                return
            }
            do {
                let accounts = try JSONDecoder().decode([Account].self, from: data)
                WalletManager.Accounts = accounts
                seal.fulfill(accounts)
            } catch {
                let error = WalletError.custom("Decode accounts failed")
                HUDManager.shared.showError(error: error)
                seal.reject(error)
            }
            
//            Shared.dataCache.fetch(key: IMPCacheKey.accountCacheKey).onSuccess { data in
//                do {
//                    let accounts = try JSONDecoder().decode([Account].self, from: data)
//                    WalletManager.Accounts = accounts
//                    seal.fulfill(accounts)
//                } catch {
//                    let error = WalletError.custom("Decode accounts failed")
//                    HUDManager.shared.showError(error: error)
//                    seal.reject(error)
//                }
//            }.onFailure { error in
//                let error = WalletError.custom("Decode accounts failed")
//                HUDManager.shared.showError(error: error)
//                seal.reject(error)
//            }
            
        }
    }
    
    class func createAccount() {
        
        let oldPaths = WalletManager.shared.keystore!.paths.keys
        
        do {
            try WalletManager.shared.keystore?.createNewChildAccount()
            try WalletManager.shared.saveKeystore(WalletManager.shared.keystore!)
            
            let name = "\(Setting.WalletName) \(Constant.randomEmoji())"
            
            let newPaths = WalletManager.shared.keystore!.paths.keys
            
            let newPath = newPaths.filter{ !oldPaths.contains($0) }.first!
            let address = WalletManager.shared.keystore!.paths[newPath]!.address
            let account = Account(address: address, name: name, imageName: "Money_Face_\(Int.random(in: 0...16))")
            WalletManager.Accounts?.append(account)
            
//            WalletManager.storeAccountsToCache()
        } catch {
            HUDManager.shared.showError(error: WalletError.createAccountFailure)
        }
    }
    
    class func deleteAccount() {
        if WalletManager.Accounts!.count <= 1 {
            HUDManager.shared.showError(text: "Can't delete the last account")
            return
        }
        
    }
    
    class func switchAccount(account: Account) {
        
        // if same account, not change
        if account == WalletManager.currentAccount {
            return
        }
        
        WalletManager.currentAccount = account
        Defaults[\.defaultAccountIndex] = WalletManager.Accounts!.firstIndex(of: account)!
        NotificationCenter.default.post(name: .accountChange, object: nil)
    }
}
