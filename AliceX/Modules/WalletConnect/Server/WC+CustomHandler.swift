//
//  WC+CustomHandler.swift
//  AliceX
//
//  Created by lmcmz on 27/9/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import WalletConnectSwift

class WCCustomHandler: WCHandler {
    override func canHandle(request: Request) -> Bool {
        return request.method == "alice_socket"
    }

    override func handle(request: Request) {
        do {
            let message = try request.parameter(of: String.self, at: 0)
//            let response = try Response(url: request.url,
//                                         value: "Success: \(message)",
//                id: request.id!)
//            self.server.send(response)

            CallRNModule.walletConnectEvent(rawData: message)
        } catch {
            HUDManager.shared.showError(text: "Handle message failed")
        }
    }
}

extension WCServerHelper {
    func sendCustomRequest(method: String = "alice_socket",
                           message: [String]) {
        guard let server = self.server,
            let session = self.session else {
            return
        }

        let wcURL = session.url

        do {
            let request = try Request(url: wcURL,
                                      method: method,
                                      params: message)
            server.send(request)
        } catch {
            HUDManager.shared.showError(text: "Send Custom Func failed")
        }
    }
}
