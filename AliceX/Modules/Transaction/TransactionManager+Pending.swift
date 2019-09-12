//
//  TransactionManager+Pending.swift
//  AliceX
//
//  Created by lmcmz on 11/9/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import web3swift

private var TransactionWebSocketKey = "TransactionWebSocketKey"

extension TransactionManager: Web3SocketDelegate {
//    var socketProvider: InfuraWebsocketProvider {
//        get {
//            let currentNet = Web3Net.currentNetwork.network
//            let provider = InfuraWebsocketProvider(currentNet, delegate: TransactionManager.shared)!
//            return (objc_getAssociatedObject(self, &TransactionWebSocketKey) as? InfuraWebsocketProvider) ?? provider
//        }
//        set {
//            objc_setAssociatedObject(self, &TransactionWebSocketKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//    }

    func received(message: Any) {
        print(message)
    }

    func gotError(error: Error) {
        print(error.localizedDescription)
    }
}
