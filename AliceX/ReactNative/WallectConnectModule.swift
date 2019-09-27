//
//  WallectConnectModule.swift
//  AliceX
//
//  Created by lmcmz on 27/9/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation

@objc(WallectConnectModule)
class WallectConnectModule: NSObject {
    
    @objc func create() {
        WCClientHelper.shared.create()
    }
    
    @objc func send(message: String, isServer: Bool) {
        if isServer {
            serverSend(method: "alice_socket", parameters: [message])
        } else {
            clientSend(method: "alice_socket", parameters: [message])
        }
    }
    
    func serverSend(method: String, parameters: [String]) {
        WCServerHelper.shared.sendCustomRequest(method: method, message: parameters)
    }
    
    func clientSend(method: String, parameters: [String]) {
        WCClientHelper.shared.sendCustomRequest(method: method, message: parameters) { (response) in
            do {
                let result = try response.result(as: String.self)
                CallRNModule.walletConnectEvent(rawData: result)
            } catch {
                print("Decode failed")
            }
        }
    }
}
