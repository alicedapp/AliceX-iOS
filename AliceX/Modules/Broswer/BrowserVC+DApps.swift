//
//  BrowserVC+DApps.swift
//  AliceX
//
//  Created by lmcmz on 17/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import web3swift
import BigInt

extension BrowserViewController: WKScriptMessageHandler {
    
    func notifyFinish(callbackID: Int, value: String) {
        
        let script: String = "executeCallback(\(callbackID), null, \"\(value)\")"
        webview.evaluateJavaScript(script, completionHandler: nil)
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let message = message
        
        WalletManager.web3Net.browserFunctions
        
        switch message.name {
        case Method.signPersonalMessage.rawValue:
            guard var body = message.body as? [String: AnyObject] else { return }
            var object = body["object"] as? [String: AnyObject]
            var dataString = object!["data"] as! String
            TransactionManager.showSignMessageView(message: dataString) { (signData) in
                self.notifyFinish(callbackID: 8888, value: signData)
            }
        case Method.signMessage.rawValue:
            
            print("signMessage")
        case Method.signTransaction.rawValue:
            guard var body = message.body as? [String: AnyObject] else { return }
            var transactionJSON = body["object"] as! [String: Any]
            if !transactionJSON.keys.contains("value") {
                transactionJSON["value"] = String(BigUInt(0))
            }
            guard let _ = EthereumTransaction.fromJSON(transactionJSON) else {return}
            guard let options = TransactionOptions.fromJSON(transactionJSON) else {return}
            var transactionOptions = TransactionOptions()
            transactionOptions.from = options.from
            transactionOptions.to = options.to
            transactionOptions.value = options.value != nil ? options.value! : BigUInt(0)
            
            let realValue = Double(transactionOptions.value!) / Double(pow(Double(10), Double(17)))
            
            TransactionManager.showSignTransactionView(to: options.to!.address,
                                                       value: String(realValue),
                                                       data: "") { (signData) in
                                                        self.notifyFinish(callbackID: 8888, value: signData)
            }
            
            print("signTransaction")
            
        case Method.signTypedMessage.rawValue:
            print("signTypedMessage")
            
        case Method.sendTransaction.rawValue:
            print("sendTransaction")
        default:
            print("Error")
        }
    }
}
