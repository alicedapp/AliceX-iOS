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

    // MARK: RCTEventEmitter

    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChange),
                                               name: UIDevice.orientationDidChangeNotification, object: nil)
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

    // Daplet
    static func dappletEvent(message: String) {
        guard let rnEventEmitter = AppDelegate.rnBridge().module(forName: "CallRNModule") as? CallRNModule else {
            print("CallRNModule - Failed to bridge")
            return
        }

        let dappletInfo: [String: Any] = [dappletKey: message]
        rnEventEmitter.sendEvent(withName: aliceEvent, body: dappletInfo)
    }
}
