//
//  WalletCoreManager.swift
//  AliceX
//
//  Created by lmcmz on 24/10/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import TrustWalletCore

class WalletCore {
    static let shared = WalletCore()
    
    var wallet: HDWallet?
    
    class func hasWallet() -> Bool {
        if WalletCore.shared.wallet != nil {
            return true
        }
        return false
    }
    
    func create(mnemonic: String) {
        wallet = HDWallet(mnemonic: mnemonic, passphrase: "")
        
    }
}

