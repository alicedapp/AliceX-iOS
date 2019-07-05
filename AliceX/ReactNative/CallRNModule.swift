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
    
    static let walletChangedEvent = "WalletChange"
    static let address = "walletAddress"
    
    // MARK: RCTEventEmitter
    override func supportedEvents() -> [String]! {
        return [CallRNModule.walletChangedEvent]
    }
    
    static func sendWalletChangedEvent(address: String) {
        guard let rnEventEmitter = AppDelegate.rnBridge().module(forName: "CallRNModule") as? CallRNModule else {
                print("CallRNModule - Failed to bridge")
                return
        }
        
        let counterEventInfo: [String: Any] = [address: address]
        rnEventEmitter.sendEvent(withName: walletChangedEvent, body: counterEventInfo)
    }
}
