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
import WebKit

extension BrowserViewController: WKScriptMessageHandler {
    func notifyFinish(callbackID: Int64, value: String) {
        let script: String = "window.ethereum.sendResponse(\(callbackID), \"\(value)\")"
        webview.evaluateJavaScript(script, completionHandler: nil)
    }

    func userContentController(_: WKUserContentController,
                               didReceive message: WKScriptMessage) {
        let json = message.json
        print(json)
        guard let name = json["name"] as? String,
            let method = ETHDAppMethod(rawValue: name),
            let id = json["id"] as? Int64 else {
            return
        }

        switch method {
        case .requestAccounts:
            let address = WalletManager.currentAccount!.address
            webview?.evaluateJavaScript("window.ethereum.setAddress(\"\(address)\");", completionHandler: nil)
            webview?.evaluateJavaScript("window.ethereum.sendResponse(\(id), [\"\(address)\"])", completionHandler: nil)
        case .signPersonalMessage:
            guard let body = message.body as? [String: AnyObject] else { return }
            let object = body["object"] as? [String: AnyObject]
            let dataString = object!["data"] as! String
            TransactionManager.showSignMessageView(message: dataString) { signData in
                self.notifyFinish(callbackID: id, value: signData)
            }
        case .signMessage:
            print("signMessage")
        case .signTransaction:
//             .sendTransaction:
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

        case .signTypedMessage:
            print("signTypedMessage")

        default:
            print("Error")
        }
    }
}

extension WKScriptMessage {
    var json: [String: Any] {
        if let string = body as? String,
            let data = string.data(using: .utf8),
            let object = try? JSONSerialization.jsonObject(with: data, options: []),
            let dict = object as? [String: Any] {
            return dict
        } else if let object = body as? [String: Any] {
            return object
        }
        return [:]
    }
}
