//
//  WalletModule.swift
//  AliceX
//
//  Created by lmcmz on 11/6/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation

@objc(WalletModule)
class WalletModule: NSObject {
    
    // This is the method exposed to React Native. It can't handle
    // the first parameter being named. http://stackoverflow.com/a/39840952/155186
    @objc func sendTransaction(_ to: String, value: String, callback successCallback: @escaping RCTResponseSenderBlock) {
//    @objc func sendTransaction(_ to:String, value: String) {
    
        // You won't be on the main thread when called from JavaScript
        DispatchQueue.main.async {
            TransactionManager.showRNCustomPaymentView(toAddress: to, amount: value, success: { (tx) -> Void in
                successCallback([tx])
            })
        }
    }
    
    @objc func getAddress(_ successCallback: @escaping RCTResponseSenderBlock) {
        DispatchQueue.main.async {
            guard let address = try? TransactionManager.getAddress()
                else {
                    successCallback(["No address"])
                    return
            }
            successCallback([address])
        }
    }
    
    @objc func smartContract(_ contractAddress: String, method: String, ABI: String,
                             parameter: [Any], callback successCallback: @escaping RCTResponseSenderBlock) {
        //    @objc func sendTransaction(_ to:String, value: String) {
        
        // You won't be on the main thread when called from JavaScript
        DispatchQueue.main.async {
            guard let tx = try? TransactionManager.callSmartContract(contractAddress: contractAddress,
                                                                     method: method, ABI: ABI, parameter: parameter)
                else {
                successCallback(["error"])
                return
            }
            successCallback([tx])
        }
    }
}
