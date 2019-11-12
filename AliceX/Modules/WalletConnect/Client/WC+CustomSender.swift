//
//  WC+CustomSender.swift
//  AliceX
//
//  Created by lmcmz on 27/9/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import WalletConnectSwift

extension WCClientHelper {
    func sendCustomRequest(method: String = "alice_socket",
                           message: [String],
                           responseBlock: @escaping Client.RequestResponse) {
        guard let walletConnect = WCClientHelper.shared.walletConnect,
            let client = walletConnect.client else {
            return
        }

        let wcURL = walletConnect.session.url

        do {
            let request = try Request(url: wcURL,
                                      method: method,
                                      params: message)
            try client.send(request, completion: responseBlock)
        } catch {
            HUDManager.shared.showError(text: "Send Custom Func failed")
        }
    }

    func handler(response _: Response) {}

    func reciveCustomRequest(request _: Request) {}
}
