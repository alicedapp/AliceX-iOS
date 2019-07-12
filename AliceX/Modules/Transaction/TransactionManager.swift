//
//  TransactionManager.swift
//  AliceX
//
//  Created by lmcmz on 10/6/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit
import SPStorkController
import web3swift
import BigInt

class TransactionManager {
    static let shared = TransactionManager()
    
    // MARK: - Payment Popup
    
    class func showPaymentView(toAddress: String,
                               amount: String,
                               data: String,
                               symbol: String, success: @escaping StringBlock) {
        let topVC = UIApplication.topViewController()
        let modal = PaymentPopUp.make(toAddress: toAddress, amount: amount, data: data,symbol: symbol, success: success)
        let transitionDelegate = SPStorkTransitioningDelegate()
        transitionDelegate.customHeight = 400
        modal.transitioningDelegate = transitionDelegate
        modal.modalPresentationStyle = .custom
        topVC?.present(modal, animated: true, completion: nil)
    }
    
    class func showRNCustomPaymentView(toAddress: String, amount: String,
                                       height: CGFloat = 500, data: String,
                               success: @escaping StringBlock) {
        let topVC = UIApplication.topViewController()
        let modal = RNCustomPopUp.make(toAddress: toAddress, amount: amount,
                                       height: height, data: data, successBlock: success)
        let transitionDelegate = SPStorkTransitioningDelegate()
        transitionDelegate.customHeight = height
        modal.transitioningDelegate = transitionDelegate
        modal.modalPresentationStyle = .custom
        topVC?.present(modal, animated: true, completion: nil)
    }
    
    // MARK: - Smart Contract Popup
    
    class func showContractWriteView(contractAddress: String,
                                     functionName: String,
                                     abi: String,
                                     parameters: [Any],
                                     value: String,
                                     extraData: String,
                                     success: @escaping StringBlock) {
        let topVC = UIApplication.topViewController()
        let modal = ContractPopUp.make(contractAddress: contractAddress,
                                       functionName: functionName, parameters: parameters,
                                       extraData: extraData, value: value, abi: abi, success: success)
        let transitionDelegate = SPStorkTransitioningDelegate()
        transitionDelegate.customHeight = 500
        modal.transitioningDelegate = transitionDelegate
        modal.modalPresentationStyle = .custom
        topVC?.present(modal, animated: true, completion: nil)
    }
    
    class func getAddress() throws -> String {
        guard let address = WalletManager.wallet?.address else { throw WalletError.accountDoesNotExist }
        return address
    }

    // MARK: - Balance
    
    public func etherBalanceSync() throws -> String {
        guard let address = WalletManager.wallet?.address else { throw WalletError.accountDoesNotExist }
        guard let ethereumAddress = EthereumAddress(address) else { throw WalletError.invalidAddress }
        
        guard let balanceInWeiUnitResult = try? WalletManager.web3Net.eth.getBalance(address: ethereumAddress) else {
            throw WalletError.insufficientBalance
        }

        guard let balanceInEtherUnitStr = Web3.Utils.formatToEthereumUnits(balanceInWeiUnitResult,
                                                                           toUnits: Web3.Utils.Units.eth,
                                                                           decimals: 6, decimalSeparator: ".")
            else { throw WalletError.conversionFailure }
        
        return balanceInEtherUnitStr
    }

    public func etherBalance(completion: @escaping (String?) -> Void) {
        DispatchQueue.global().async {
            let balance = try? self.etherBalanceSync()
            DispatchQueue.main.async {
                completion(balance)
            }
        }
    }

    // MARK: - Send Transaction

    public func sendEtherSync(to address: String, amount: String, data: String, password: String) throws -> String {
        return try sendEtherSync(to: address, amount: amount, dataString: data, password: password, gasPrice: nil)
    }

    public func sendEtherSync(to address: String, amount: String, dataString: String,
                              password: String, gasPrice: String?) throws -> String {
        
        guard let toAddress = EthereumAddress(address) else {
            throw WalletError.invalidAddress
        }

        let etherBalance = try etherBalanceSync()
        guard let etherBalanceInDouble = Double(etherBalance) else {
            throw WalletError.conversionFailure
        }

        guard let amountInDouble = Double(amount) else {
            throw WalletError.conversionFailure
        }

        guard etherBalanceInDouble >= amountInDouble else {
            throw WalletError.insufficientBalance
        }
        
        guard let _ = WalletManager.web3Net.provider.attachedKeystoreManager else {
            throw WalletError.malformedKeystore
        }

        let walletAddress = EthereumAddress(WalletManager.wallet!.address)!
        let contract = WalletManager.web3Net.contract(Web3.Utils.coldWalletABI, at: toAddress, abiVersion: 2)!
        let value = Web3.Utils.parseToBigUInt(amount, units: .eth)
        var options = TransactionOptions.defaultOptions
        options.value = value
        options.from = walletAddress
        options.gasPrice = .automatic
        options.gasLimit = .automatic

        let data = dataString.data(using: .utf8)!
        
        let tx = contract.write(
            "fallback",
            parameters: [AnyObject](),
            extraData: data,
            transactionOptions: options)!

        do {
            let sendResult = try tx.send()
            return sendResult.hash
        } catch let error as Web3Error {
            HUDManager.shared.showError(text: error.errorDescription)
        }
//
        return "error"
    }
    
    // MARK: - Call Smart Contract

    public class func writeSmartContract(contractAddress: String,
                                         functionName: String,
                                         abi: String,
                                         parameters: [Any],
                                         extraData: Data = Data(),
                                         value: String = "0.0") throws -> String {
        
        guard let address = WalletManager.wallet?.address else {
            throw WalletError.invalidAddress
        }
        
        guard let walletAddress = EthereumAddress(address) else {
            throw WalletError.invalidAddress
        }
        
        guard let contractAddress = EthereumAddress(contractAddress) else {
            throw WalletError.invalidAddress
        }
        
        guard let keystore = WalletManager.web3Net.provider.attachedKeystoreManager else {
            throw WalletError.malformedKeystore
        }
        print(keystore)
        
        let abiVersion = 2
        let contract = WalletManager.web3Net.contract(abi, at: contractAddress, abiVersion: abiVersion)
        let amount = Web3.Utils.parseToBigUInt(value, units: .eth)
        
        var options = TransactionOptions.defaultOptions
        options.value = amount
        options.from = walletAddress
        options.gasPrice = .automatic
        options.gasLimit = .automatic
        let tx = contract!.write(
            functionName,
            parameters: parameters as [AnyObject],
            extraData: extraData,
            transactionOptions: options)!
        
        do {
            let sendResult = try tx.send()
            return sendResult.hash
        } catch let error as Web3Error {
            HUDManager.shared.showError(text: error.errorDescription)
        }
        
        return "Error"
    }
    
    public class func readSmartContract(contractAddress: String, functionName: String,
                                        abi: String, parameters: [Any], value: String = "0.0") throws -> String {
        
        guard let address = WalletManager.wallet?.address else {
            throw WalletError.invalidAddress
        }
        
        guard let walletAddress = EthereumAddress(address) else {
            throw WalletError.invalidAddress
        }
        
        guard let contractAddress = EthereumAddress(contractAddress) else {
            throw WalletError.invalidAddress
        }
        
        let abiVersion = 2
        let extraData: Data = Data()
        let contract = WalletManager.web3Net.contract(abi, at: contractAddress, abiVersion: abiVersion)
        let amount = Web3.Utils.parseToBigUInt(value, units: .eth)
        
        var options = TransactionOptions.defaultOptions
        options.value = amount
        options.from = walletAddress
        options.gasPrice = .automatic
        options.gasLimit = .automatic
        let tx = contract!.read(
            functionName,
            parameters: parameters as [AnyObject],
            extraData: extraData,
            transactionOptions: options)
        
        guard let sendResult = try? tx?.call() else {
            throw WalletError.networkFailure
        }
        print(sendResult)
        
        return ""
    }
    
    // MARK: - Sign
    
    class func showSignMessageView(message: String, success: @escaping StringBlock) {
        let topVC = UIApplication.topViewController()
        let modal = SignMessagePopUp.make(message: message, success: success)
        let transitionDelegate = SPStorkTransitioningDelegate()
        transitionDelegate.customHeight = 480
        modal.transitioningDelegate = transitionDelegate
        modal.modalPresentationStyle = .custom
        topVC?.present(modal, animated: true, completion: nil)
    }
    
    class func signMessage(message: String) throws -> String? {
        
        guard let address = WalletManager.wallet?.address else {
            throw WalletError.invalidAddress
        }
        
        guard let walletAddress = EthereumAddress(address) else {
            throw WalletError.invalidAddress
        }
        
        guard let keystore = WalletManager.web3Net.provider.attachedKeystoreManager else {
            throw WalletError.malformedKeystore
        }
        
//        let msgData = try! message.data(using: .utf8)
        let msgData = Data.fromHex(message)
        
        do {
            let signedData = try Web3Signer.signPersonalMessage(msgData!,
                                                                 keystore: keystore,
                                                                 account: walletAddress,
                                                                 password: Setting.password)
            return (signedData?.toHexString().addHexPrefix())!
        } catch {
            throw WalletError.messageFailedToData
        }
    }
    
    class func signMessage(data: Data) throws -> String? {
        
        guard let address = WalletManager.wallet?.address else {
            throw WalletError.invalidAddress
        }
        
        guard let walletAddress = EthereumAddress(address) else {
            throw WalletError.invalidAddress
        }
        
        guard let keystore = WalletManager.web3Net.provider.attachedKeystoreManager else {
            throw WalletError.malformedKeystore
        }
        
        do {
            let signedData = try Web3Signer.signPersonalMessage(data,
                                                                keystore: keystore,
                                                                account: walletAddress,
                                                                password: Setting.password)
            return (signedData?.toHexString().addHexPrefix())!
        } catch {
            throw WalletError.messageFailedToData
        }
    }
    
    class func showSignTransactionView(to:String, value:String, data:String, success: @escaping StringBlock) {
        let topVC = UIApplication.topViewController()
        let modal = SignTransactionPopUp.make(toAddress: to, amount: value, data: data, success: success)
        let transitionDelegate = SPStorkTransitioningDelegate()
        transitionDelegate.customHeight = 630
        modal.transitioningDelegate = transitionDelegate
        modal.modalPresentationStyle = .custom
        topVC?.present(modal, animated: true, completion: nil)
    }
    
    class func signTransaction(to address: String, amount: String, dataString: String) throws -> String {
        
        guard let toAddress = EthereumAddress(address) else {
            throw WalletError.invalidAddress
        }
        
        guard let address = WalletManager.wallet?.address else {
            throw WalletError.invalidAddress
        }
        
        guard let walletAddress = EthereumAddress(address) else {
            throw WalletError.invalidAddress
        }
        
        guard let keystore = WalletManager.web3Net.provider.attachedKeystoreManager else {
            throw WalletError.malformedKeystore
        }
        
        let value = Web3.Utils.parseToBigUInt(amount, units: .eth)
        var options = TransactionOptions.defaultOptions
        options.value = value
        options.from = walletAddress
        options.gasPrice = .automatic
        options.gasLimit = .automatic
        
        let data = dataString.data(using: .utf8)
        
        var tx = EthereumTransaction(to: toAddress, data: data!, options: options)
        
        do {
            try Web3Signer.signTX(transaction: &tx,
                                  keystore: keystore,
                                  account: walletAddress,
                                  password: Setting.password)
            
            print(tx.description)
            return (tx.encode(forSignature: false, chainID: nil)?.toHexString().addHexPrefix())!
            // TODO return JSON
//            return tx.toJsonString()
        } catch {
            HUDManager.shared.showError()
        }
        
        return "error"
    }
}
