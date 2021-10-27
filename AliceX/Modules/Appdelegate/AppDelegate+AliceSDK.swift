//
//  AppDelegate+AliceSDK.swift
//  AliceX
//
//  Created by lmcmz on 16/8/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import BigInt
import Foundation

func handleAliceURL(url: URL) -> Bool {
    guard let scheme = url.scheme,
          scheme.localizedCaseInsensitiveCompare("alice") == .orderedSame else {
        return false
    }

    var dict = [String: String]()
    let components = URLComponents(url: url, resolvingAgainstBaseURL: false)!

    if components.host == "rn" {
        assert(false, "rn code")
        return true
    }

    if let queryItems = components.queryItems {
        for item in queryItems {
            dict[item.name] = item.value!
        }
    }

    guard let method = dict["method"], let callback = dict["callback"] else {
        return false
    }

    switch method {
    case "getAddress":
        let url = URL(string: "\(callback)://")!
            .appending("method", value: method)
            .appending("address", value: WalletManager.currentAccount!.address)
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    case "signMessage":

        guard let messsage = dict["message"] else {
            return false
        }

        let data = messsage.data(using: .utf8)?.toHexString().addHexPrefix()
        TransactionManager.showSignMessageView(message: data!) { signed in
            let url = URL(string: "\(callback)://")!
                .appending("method", value: method)
                .appending("sign", value: signed)
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    case "signTransaction":
        guard let to = dict["to"],
              let valueRaw = dict["value"],
              let dataRaw = dict["data"] else {
            return false
        }
        guard let value = BigUInt(valueRaw.stripHexPrefix(), radix: 16),
              let data = Data.fromHex(dataRaw) else {
            HUDManager.shared.showError(text: "Parameters is invaild")
            return false
        }
        TransactionManager.showSignTransactionView(to: to, value: value, data: data) { signed in
            let url = URL(string: "\(callback)://")!
                .appending("method", value: method)
                .appending("sign", value: signed)
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }

    case "sendTransaction":
        guard let to = dict["to"],
              let valueRaw = dict["value"] else {
            return false
        }
        guard let value = BigUInt(valueRaw.stripHexPrefix(), radix: 16) else {
            HUDManager.shared.showError(text: "Parameters is invaild")
            return false
        }

        TransactionManager.showPaymentView(toAddress: to,
                                           amount: value,
                                           data: Data(),
                                           coin: Coin.coin(chain: .Ethereum)) { txHash in
            let url = URL(string: "\(callback)://")!
                .appending("method", value: method)
                .appending("txHash", value: txHash)
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }

    default:
        break
    }

    return true
}
