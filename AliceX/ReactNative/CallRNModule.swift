//
//  CallRNModule.swift
//  AliceX
//
//  Created by lmcmz on 5/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import React

@objc(CallRNModule)
class CallRNModule: RCTEventEmitter {
    static let walletChangedEvent = "walletChangedEvent"
    static let addressKey = "address"

    static let networkChangedEvent = "networkChangedEvent"
    static let networkKey = "network"

    // MARK: RCTEventEmitter

    override func supportedEvents() -> [String]! {
        return [CallRNModule.walletChangedEvent,
                CallRNModule.networkChangedEvent]
    }

    static func sendWalletChangedEvent(address: String) {
        guard let rnEventEmitter = AppDelegate.rnBridge().module(forName: "CallRNModule") as? CallRNModule else {
            print("CallRNModule - Failed to bridge")
            return
        }

        let walletInfo: [String: Any] = [addressKey: address]
        rnEventEmitter.sendEvent(withName: walletChangedEvent, body: walletInfo)
    }

    static func sendNetworkChangedEvent(network: Web3NetEnum) {
        guard let rnEventEmitter = AppDelegate.rnBridge().module(forName: "CallRNModule") as? CallRNModule else {
            print("CallRNModule - Failed to bridge")
            return
        }

        let networkInfo: [String: Any] = [networkKey: network.rawValue.lowercased()]
        rnEventEmitter.sendEvent(withName: networkChangedEvent, body: networkInfo)
    }
}
