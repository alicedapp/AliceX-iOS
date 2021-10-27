//
//  WalletCoreManager.swift
//  AliceX
//
//  Created by lmcmz on 24/10/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import WalletCore

class WalletCore {
    static let shared = WalletCore()
    static var wallet: HDWallet!

    class func hasWallet() -> Bool {
        if WalletCore.wallet != nil {
            return true
        }
        return false
    }

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateWallet), name: .walletChange, object: nil)
    }

    func loadFromCache() {
        guard let mnemonic = KeychainHepler.shared.fetchKeychain(key: Setting.MnemonicsKey) else {
            return
        }
        WalletCore.wallet = HDWallet(mnemonic: mnemonic, passphrase: "")
    }

    class func address(blockchain: BlockChain) -> String {
        guard let wallet = WalletCore.wallet, let account = WalletManager.currentAccount else {
            return ""
        }

        let coinType = blockchain.coinType

        switch blockchain {
        case .Ethereum:
            return account.address
        default:
            let key = wallet.getKeyForCoin(coin: coinType)
            let address = coinType.deriveAddress(privateKey: key)
            return address
        }
    }

    // MARK: - Notification

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func updateWallet() {
        let mnemonic = KeychainHepler.shared.fetchKeychain(key: Setting.MnemonicsKey)
        WalletCore.wallet = HDWallet(mnemonic: mnemonic!, passphrase: "")
    }
}
