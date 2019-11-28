//
//  BrowserVC+DApps.swift
//  AliceX
//
//  Created by lmcmz on 17/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import BigInt
import Foundation
import web3swift

extension BrowserViewController: WKScriptMessageHandler {
    func notifyFinish(callbackID: Int, value: String) {
        let script: String = "executeCallback(\(callbackID), null, \"\(value)\")"
        webview.evaluateJavaScript(script, completionHandler: nil)
    }

    func userContentController(_: WKUserContentController, didReceive message: WKScriptMessage) {
        let message = message

        switch message.name {
        case Method.signPersonalMessage.rawValue:
            guard let body = message.body as? [String: AnyObject] else { return }
            let object = body["object"] as? [String: AnyObject]
            let dataString = object!["data"] as! String
            TransactionManager.showSignMessageView(message: dataString) { signData in
                self.notifyFinish(callbackID: 8888, value: signData)
            }
        case Method.signMessage.rawValue:
            print("signMessage")
        case Method.signTransaction.rawValue,
             Method.sendTransaction.rawValue:
            guard let body = message.body as? [String: AnyObject] else { return }
            var transactionJSON = body["object"] as! [String: Any]
            if !transactionJSON.keys.contains("value") {
                transactionJSON["value"] = String(BigUInt(0))
            }

//            let result = WalletManager.web3Net.browserFunctions.sendTransaction(transactionJSON)
//
//            self.notifyFinish(callbackID: 8888, value: result!["txhash"] as! String)

            guard let tx = EthereumTransaction.fromJSON(transactionJSON) else { return }
            guard let options = TransactionOptions.fromJSON(transactionJSON) else { return }
            let value = options.value != nil ? options.value! : BigUInt(0)

            var gasLimit = BigUInt(0)

            if transactionJSON.keys.contains("gas"), let gas = transactionJSON["gas"] as? String,
                let gasInt = BigUInt(gas.stripHexPrefix(), radix: 16) {
                gasLimit = gasInt
            }

            var gasPrice = GasPrice.average
            if tx.gasPrice != BigUInt(0) {
                gasPrice = GasPrice.custom(tx.gasPrice)
            }

            TransactionManager.showPaymentView(toAddress: tx.to.address,
                                               amount: value,
                                               data: tx.data,
                                               coin: Coin.coin(chain: .Ethereum),
                                               gasPrice: gasPrice,
                                               gasLimit: gasLimit) { signData in
                self.notifyFinish(callbackID: 8888, value: signData)
            }

        case Method.signTypedMessage.rawValue:
            print("signTypedMessage")

        default:
            print("Error")
        }
    }
}
