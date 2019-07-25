//
//  WalletModule.swift
//  AliceX
//
//  Created by lmcmz on 11/6/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import BigInt
import web3swift

@objc(WalletModule)
class WalletModule: NSObject {
    
    // This is the method exposed to React Native. It can't handle
    // the first parameter being named. http://stackoverflow.com/a/39840952/155186

    // You won't be on the main thread when called from JavaScript
//    
    @objc func getAddressCallback(_ successCallback: @escaping RCTResponseSenderBlock) {
        DispatchQueue.main.async {
            guard let address = try? TransactionManager.getAddress()
                else {
                    successCallback(["No address"])
                    return
            }
            successCallback([address])
        }
    }
    
    @objc func getAddress(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        DispatchQueue.main.async {
            guard let address = try? TransactionManager.getAddress()
                else {
                    reject("1", "Fetch address failure", nil)
                    return
            }
            resolve(address)
        }
    }
    
    @objc func getBalance(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        DispatchQueue.main.async {
            do {
                let balance = try TransactionManager.shared.etherBalanceSync()
                resolve(balance)
            } catch {
                reject("1", error.localizedDescription, nil)
            }
        }
    }
    
    @objc func sendTransaction(_ to: String, value: String, data: String,
                               resolve: @escaping RCTPromiseResolveBlock,
                               reject: @escaping RCTPromiseRejectBlock) {
        DispatchQueue.main.async {
            
            guard let value = BigUInt(value.stripHexPrefix(), radix: 16),
                let data = Data.fromHex(data) else {
                HUDManager.shared.showError(text: "Parameters is invaild")
                return
            }
            
            TransactionManager.showPaymentView(toAddress: to,
                                               amount: value,
                                               data: data,
                                               symbol: "ETH",
                                               success: { (tx) -> Void in
                                                resolve(tx)
            })
        }
    }
    
    @objc func sendTransactionWithDapplet(_ to: String, value: String, data: String,
                                          resolve: @escaping RCTPromiseResolveBlock,
                                          reject: @escaping RCTPromiseRejectBlock) {
        DispatchQueue.main.async {
            
            guard let value = BigUInt(value.stripHexPrefix(), radix: 16),
                let data = Data.fromHex(data) else {
                HUDManager.shared.showError(text: "Parameters is invaild")
                return
            }
            
            TransactionManager.showRNCustomPaymentView(toAddress: to,
                                                       amount: value, data: data,
                                                       success: { (tx) -> Void in
                resolve(tx)
            })
        }
    }
    
    @objc func signMessage(_ message: String,
                           resolve: @escaping RCTPromiseResolveBlock,
                           reject: @escaping RCTPromiseRejectBlock) {
        DispatchQueue.main.async {
            TransactionManager.showSignMessageView(message: message) { (signData) in
                resolve(signData)
            }
        }
    }
    
    @objc func signTransaction(_ to: String, value: String, data: String,
                               resolve: @escaping RCTPromiseResolveBlock,
                               reject: @escaping RCTPromiseRejectBlock) {
        DispatchQueue.main.async {
            
            guard let value = BigUInt(value.stripHexPrefix(), radix: 16),
                let data = Data.fromHex(data) else {
                HUDManager.shared.showError(text: "Parameters is invaild")
                return
            }
            
            TransactionManager.showSignTransactionView(to: to, value: value, data: data, success: { (signJson) in
                resolve(signJson)
            })
        }
    }
    
    @objc func sendToken(_ tokenAddress: String,
                         to: String,
                         value: String,
                         data: String,
                         resolve: @escaping RCTPromiseResolveBlock,
                         reject: @escaping RCTPromiseRejectBlock) {
        DispatchQueue.main.async {
            
            guard let toAddress = EthereumAddress(to),
                let token = EthereumAddress(tokenAddress),
                let value = BigUInt(value.stripHexPrefix(), radix: 16),
                let data = Data.fromHex(data) else {
                    HUDManager.shared.showError(text: "Parameters is invaild")
                    return
            }
            
            TransactionManager.showTokenView(tokenAdress: tokenAddress,
                                             toAddress: to,
                                             amount: value,
                                             data: data,
                                             success: { (txHash) in
                                                resolve(txHash)
            })
            
        }
    }
    
    @objc func transfer(to: String,
                        value: String,
                        resolve: @escaping RCTPromiseResolveBlock,
                        reject: @escaping RCTPromiseRejectBlock) {
        
        DispatchQueue.main.async {
            let vc = TransferPopUp.make(address: to, value: value)
            HUDManager.shared.showAlertVCNoBackground(viewController: vc, type: .topFloat)
            resolve("Success")
        }
    }
}
