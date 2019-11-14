//
//  WalletManager.swift
//  AliceX
//
//  Created by lmcmz on 7/6/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import SPStorkController
import web3swift

class WalletManager {
    static let shared = WalletManager()
    static var wallet: Wallet?
    static var currentNetwork: Web3NetEnum = .main

    static var customNetworkList: [Web3NetModel] = []

    #if DEBUG
        static var web3Net = Web3.InfuraRinkebyWeb3()
    #else
        static var web3Net = Web3.InfuraMainnetWeb3()
    #endif

    var keystore: BIP32Keystore?

    class func hasWallet() -> Bool {
        if WalletManager.wallet != nil {
            return true
        }
        return false
    }

    class func addKeyStoreIfNeeded() {
        if !WalletManager.hasWallet() {
            return
        }

        guard let keystore = WalletManager.shared.keystore else {
            return
        }

        if WalletManager.web3Net.provider.attachedKeystoreManager != nil {
            return
        }

        WalletManager.web3Net.addKeystoreManager(KeystoreManager([keystore]))
    }

    class func loadFromCache() {
        guard let keystore = try? WalletManager.shared.loadKeystore() else {
            return
        }
        // Load web3 net from user default
        web3Net = WalletManager.fetchFromCache()

        WalletManager.shared.loadRPCFromCache()

        WalletManager.shared.keystore = keystore
        let name = Setting.WalletName
        let keyData = try! JSONEncoder().encode(keystore.keystoreParams)
        let address = keystore.addresses!.first!.address
        let wallet = Wallet(address: address, data: keyData, name: name, isHD: true)
        WalletManager.wallet = wallet
        WalletManager.addKeyStoreIfNeeded()
    }

    class func createAccount(completion: VoidBlock?) {
//        let Mnemonics =  KeychainHepler.fetchKeychain(key: Setting.MnemonicsKey)

        if WalletManager.hasWallet() {
            HUDManager.shared.showError(text: "You already had a wallet")
            return
        }

        let bitsOfEntropy: Int = 128 // Entropy is a measure of password strength. Usually used 128 or 256 bits.
        let mnemonics = try! BIP39.generateMnemonics(bitsOfEntropy: bitsOfEntropy)!

        KeychainHepler.shared.saveToKeychain(value: mnemonics, key: Setting.MnemonicsKey)

        let keystore = try! BIP32Keystore(mnemonics: mnemonics)
        let name = Setting.WalletName
        let keyData = try! JSONEncoder().encode(keystore!.keystoreParams)
        let address = keystore!.addresses!.first!.address
        let wallet = Wallet(address: address, data: keyData, name: name, isHD: true)

        WalletManager.wallet = wallet
        WalletManager.shared.keystore = keystore
        try! WalletManager.shared.saveKeystore(keystore!)
        WalletManager.addKeyStoreIfNeeded()

        guard let completion = completion else { return }
        completion!()
    }

    class func importAccount(mnemonics: String, completion: VoidBlock?) throws {
        if WalletManager.hasWallet() {
//            throw WalletError.hasAccount
            let vc = SignYesViewController.make {
                WalletManager.replaceAccount(mnemonics: mnemonics, completion: nil)
            }
//            HUDManager.shared.showAlertVCNoBackground(viewController: vc, entryInteraction: .absorbTouches)
            HUDManager.shared.showAlertVCNoBackground(viewController: vc)
            return
        }

        guard let keystore = try? BIP32Keystore(mnemonics: mnemonics) else {
            throw WalletError.malformedKeystore
        }

        KeychainHepler.shared.saveToKeychain(value: mnemonics, key: Setting.MnemonicsKey)

        let name = Setting.WalletName
        let keyData = try! JSONEncoder().encode(keystore.keystoreParams)
        let address = keystore.addresses!.first!.address
        let wallet = Wallet(address: address, data: keyData, name: name, isHD: true)

        WalletManager.wallet = wallet
        WalletManager.shared.keystore = keystore
        try WalletManager.shared.saveKeystore(keystore)

        guard let completion = completion else { return }
        completion!()
    }

    class func replaceAccount(mnemonics: String, completion _: VoidBlock?) {
        guard let keystore = try? BIP32Keystore(mnemonics: mnemonics) else {
            // TODO: ENSURE
//            throw WalletError.malformedKeystore
            HUDManager.shared.showError(text: WalletError.malformedKeystore.errorDescription)
            return
        }
        
        do {
            KeychainHepler.shared.saveToKeychain(value: mnemonics, key: Setting.MnemonicsKey)
            let name = Setting.WalletName
            let keyData = try JSONEncoder().encode(keystore.keystoreParams)
            let address = keystore.addresses!.first!.address
            let wallet = Wallet(address: address, data: keyData, name: name, isHD: true)

            WalletManager.wallet = wallet
            WalletManager.shared.keystore = keystore
            try WalletManager.shared.saveKeystore(keystore)
            
            HUDManager.shared.showSuccess(text: "Replace wallet success")
            CallRNModule.sendWalletChangedEvent(address: address)
            NotificationCenter.default.post(name: .walletChange, object: nil)
        } catch {
            HUDManager.shared.showError(text: "Replace Wallet Failed")
        }
        
    }

    // MARK: - Notification

    class func updateNetwork(type: Web3NetEnum) {
//        let web3:web3 = Web3Net.fetchFromCache()
        do {
            let net = try WalletManager.make(type: type)
            WalletManager.web3Net = net
            addKeyStoreIfNeeded()
            WalletManager.storeInCache(type: type.model)
            WalletManager.currentNetwork = type
            NotificationCenter.default.post(name: .networkChange, object: type)

            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()

            CallRNModule.sendNetworkChangedEvent(network: type)

            UIView.animate(withDuration: 0.3) {
                UIApplication.shared.keyWindow?.backgroundColor = type.backgroundColor
                SPStorkTransitioningDelegate.backgroundColor = type.backgroundColor
                SPStorkTransitioningDelegate.changeBackground()
            }

        } catch let error as WalletError {
            HUDManager.shared.showError(text: error.errorDescription)
        } catch {
            HUDManager.shared.showError()
        }
    }
}
