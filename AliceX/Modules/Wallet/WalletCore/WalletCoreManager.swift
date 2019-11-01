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

    var wallet: HDWallet!

    class func hasWallet() -> Bool {
        if WalletCore.shared.wallet != nil {
            return true
        }
        return false
    }
    
    init() {
        let mnemonic = KeychainHepler.shared.fetchKeychain(key: Setting.MnemonicsKey)
        wallet = HDWallet(mnemonic: mnemonic!, passphrase: "")
    }
    
    func address(blockchain: BlockChain) -> String {
        let coinType = blockchain.coinType
        
        switch blockchain {
        case .Ethereum:
            return WalletManager.wallet!.address
        default:
            let key = wallet.getKeyForCoin(coin: coinType)
            let address = coinType.deriveAddress(privateKey: key)
            return address
        }
    }
}
