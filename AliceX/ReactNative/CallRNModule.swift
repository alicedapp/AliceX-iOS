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
    static let shared = CallRNModule()

    static let aliceEvent = "aliceEvent"
    static let addressKey = "address"
    static let networkKey = "network"
    static let orientationKey = "orientation"
    static let dappletKey = "dapplets"
    static let deeplinkKey = "deeplink"
    static let pendingTxComplete = "pendingTxComplete"
    static let walletConnectKey = "walletconnect"
    static let isDarkMode = "isDarkMode"

    // MARK: RCTEventEmitter

    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChange),
                                               name: UIDevice.orientationDidChangeNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(pendingTxComplete), name: .removePendingTransaction, object: nil)
    }

    override func supportedEvents() -> [String]! {
        return [CallRNModule.aliceEvent]
    }

    static func sendWalletChangedEvent(address: String) {
        guard let rnEventEmitter = AppDelegate.rnBridge().module(forName: "CallRNModule") as? CallRNModule else {
            print("CallRNModule - Failed to bridge")
            return
        }

        let walletInfo: [String: Any] = [addressKey: address]
        rnEventEmitter.sendEvent(withName: aliceEvent, body: walletInfo)
    }

    static func sendNetworkChangedEvent(network: Web3NetEnum) {
        guard let rnEventEmitter = AppDelegate.rnBridge().module(forName: "CallRNModule") as? CallRNModule else {
            print("CallRNModule - Failed to bridge")
            return
        }

        let networkInfo: [String: Any] = [networkKey: network.model.toJSONString()]
        rnEventEmitter.sendEvent(withName: aliceEvent, body: networkInfo)
    }

    @objc func orientationChange() {
        guard let rnEventEmitter = AppDelegate.rnBridge().module(forName: "CallRNModule") as? CallRNModule else {
            print("CallRNModule - Failed to bridge")
            return
        }

        let result = CallRNModule.getOrientation()
        let orientationInfo: [String: Any] = [CallRNModule.orientationKey: result]
        rnEventEmitter.sendEvent(withName: CallRNModule.aliceEvent, body: orientationInfo)
    }

    static func getOrientation() -> String {
        var result = "portrait"
        switch UIDevice.current.orientation {
        case .landscapeLeft:
            result = "landscapeLeft"
        case .landscapeRight:
            result = "landscapeRight"
        case .portrait:
            result = "portrait"
        case .portraitUpsideDown:
            result = "portraitUpsideDown"
        default:
            result = "portrait"
        }
        return result
    }

    // Depp Link
    static func deeplinkEvent(url: String) {
        guard let rnEventEmitter = AppDelegate.rnBridge().module(forName: "CallRNModule") as? CallRNModule else {
            print("CallRNModule - Failed to bridge")
            return
        }

        let info: [String: Any] = [deeplinkKey: url]
        rnEventEmitter.sendEvent(withName: aliceEvent, body: info)
    }

    // Daplet
    static func dappletEvent(message: String) {
        guard let rnEventEmitter = AppDelegate.rnBridge().module(forName: "CallRNModule") as? CallRNModule else {
            print("CallRNModule - Failed to bridge")
            return
        }

        let dappletInfo: [String: Any] = [dappletKey: message]
        rnEventEmitter.sendEvent(withName: aliceEvent, body: dappletInfo)
    }

    // WalletConnect
    static func walletConnectEvent(rawData: String) {
        guard let rnEventEmitter = AppDelegate.rnBridge().module(forName: "CallRNModule") as? CallRNModule else {
            print("CallRNModule - Failed to bridge")
            return
        }
        let dappletInfo: [String: Any] = [walletConnectKey: rawData]
        rnEventEmitter.sendEvent(withName: aliceEvent, body: dappletInfo)
    }

    // Pending TX
    @objc func pendingTxComplete(noti: Notification) {
        guard let userInfo = noti.userInfo,
            let item = userInfo["item"],
            let isSuccess = userInfo["isSuccess"] else {
            return
        }

        guard let rnEventEmitter = AppDelegate.rnBridge().module(forName: "CallRNModule") as? CallRNModule else {
            print("CallRNModule - Failed to bridge")
            return
        }

        let pinItem = item as! PinItem
        let success = isSuccess as! Bool

        let body = ["txHash": pinItem.txHash, "isSuccess": success] as [String: Any]
        let info: [String: Any] = [CallRNModule.pendingTxComplete: body]
        rnEventEmitter.sendEvent(withName: CallRNModule.aliceEvent, body: info)
    }

    // MARK: - Theme Mode Change

    @available(iOS 12.0, *)
    static func isDarkMode(style: UIUserInterfaceStyle) {
        guard let rnEventEmitter = AppDelegate.rnBridge().module(forName: "CallRNModule") as? CallRNModule else {
            print("CallRNModule - Failed to bridge")
            return
        }
        let info: [String: Any] = [isDarkMode: style == .dark]
        rnEventEmitter.sendEvent(withName: aliceEvent, body: info)
    }
}
