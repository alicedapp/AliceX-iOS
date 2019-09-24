//
//  WalletConnectServerHandler.swift
//  AliceX
//
//  Created by lmcmz on 24/9/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import WalletConnectSwift

class WCHandler: RequestHandler {
    
    weak var sever: Server!

    init(server: Server) {
        self.sever = server
    }

    func canHandle(request: Request) -> Bool {
        return false
    }

    func handle(request: Request) {
        // to override
    }
}

class SignTransactionHandler: WCHandler {
    
    override func canHandle(request: Request) -> Bool {
        return request.method == "eth_signTransaction"
    }
    
    override func handle(request: Request) {
    }
    
}

class PersonalSignHandler: WCHandler {

    override func canHandle(request: Request) -> Bool {
        return request.method == "personal_sign"
    }
    
    override func handle(request: Request) {
        do {
            
            var messageBytes = try request.parameter(of: String.self, at: 0)
            var address = try request.parameter(of: String.self, at: 1)
            
            // TODO: Change way to mach
            if address.count != 42 {
                swap(&address, &messageBytes)
            }
            
            if address.lowercased() != WalletManager.wallet?.address.lowercased() {
               sever.send(.reject(request))
                HUDManager.shared.showError(text: "Address Not Matched")
               return
           }

            guard let decodedMessage = messageBytes.hexDecodeUTF8 else {
                sever.send(.reject(request))
                HUDManager.shared.showError(text: "Message decode failed")
                return
            }
            
            onMainThread {
                TransactionManager.showSignMessageView(message: messageBytes) { (signed) in
                    let response = try! Response(url: request.url, value: signed, id: request.id!)
                    self.sever.send(response)
                }
            }
            
//            let signed = try TransactionManager.signMessage(message: Data.fromHex(messageBytes)!)
       } catch {
           sever.send(.invalid(request))
           return
       }
    }
}
