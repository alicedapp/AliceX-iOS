//
//  WCClient.swift
//  AliceX
//
//  Created by lmcmz on 26/9/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import PromiseKit
import WalletConnectSwift

protocol WCClientDelegate {
    func failedToConnect()
    func didConnect()
    func didDisconnect()
}

class WCClient {
    var isConnecting: Bool = false
    var client: Client!
    var session: Session!
    var delegate: WCClientDelegate
    let sessionKey = "sessionKey"

    init(delegate: WCClientDelegate) {
        self.delegate = delegate
    }

    func connect() -> Promise<String> {
        return Promise<String> { seal in
            let aliceLogo = URL(string: "https://static1.squarespace.com/static/5c62768baf4683e94383848a/t/5ceca03be2c4834cdc18a838/1568564936191/?format=1500w")!

            let wcUrl = WCURL(topic: UUID().uuidString,
                              bridgeURL: URL(string: "https://bridge.walletconnect.org")!,
                              key: try! randomKey())
            let clientMeta = Session.ClientMeta(name: "Alice",
                                                description: "Alice Crypto Wallet Wallet Connect Service",
                                                icons: [aliceLogo],
                                                url: URL(string: "https://alicedapp.com")!)
            let dAppInfo = Session.DAppInfo(peerId: UUID().uuidString, peerMeta: clientMeta)
            client = Client(delegate: self, dAppInfo: dAppInfo)
            print("WalletConnect URL: \(wcUrl.absoluteString)")

            do {
                try client.connect(to: wcUrl)
                seal.fulfill(wcUrl.absoluteString)
            } catch {
                seal.reject(WalletError.custom("Wallet Connect Create Failed"))
            }
        }
    }

    func connect() -> String {
        // gnosis wc bridge: https://safe-walletconnect.gnosis.io
        // test bridge with latest protocol version: https://bridge.walletconnect.org

        let aliceLogo = URL(string: "https://static1.squarespace.com/static/5c62768baf4683e94383848a/t/5ceca03be2c4834cdc18a838/1568564936191/?format=1500w")!

        let wcUrl = WCURL(topic: UUID().uuidString,
                          bridgeURL: URL(string: "https://bridge.walletconnect.org")!,
                          key: try! randomKey())
        let clientMeta = Session.ClientMeta(name: "Alice",
                                            description: "Alice Wallet Connect ",
                                            icons: [aliceLogo],
                                            url: URL(string: "https://alicedapp.com")!)
        let dAppInfo = Session.DAppInfo(peerId: UUID().uuidString, peerMeta: clientMeta)
        client = Client(delegate: self, dAppInfo: dAppInfo)
        print("WalletConnect URL: \(wcUrl.absoluteString)")

        do {
            try client.connect(to: wcUrl)
        } catch {
            HUDManager.shared.showError(text: "Wallet Connect Create Failed")
        }
        return wcUrl.absoluteString
    }

    func reconnectIfNeeded() {
        if let oldSessionObject = UserDefaults.standard.object(forKey: sessionKey) as? Data,
            let session = try? JSONDecoder().decode(Session.self, from: oldSessionObject) {
            client = Client(delegate: self, dAppInfo: session.dAppInfo)
            try? client.reconnect(to: session)
        }
    }

    // https://developer.apple.com/documentation/security/1399291-secrandomcopybytes
    private func randomKey() throws -> String {
        var bytes = [Int8](repeating: 0, count: 32)
        let status = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)
        if status == errSecSuccess {
            return Data(bytes: bytes, count: 32).toHexString()
        } else {
            // we don't care in the example app
            enum TestError: Error {
                case unknown
            }
            throw TestError.unknown
        }
    }
}

extension WCClient: ClientDelegate {
    func client(_: Client, didFailToConnect _: WCURL) {
        delegate.failedToConnect()
        isConnecting = false
    }
    
    func client(_ client: Client, didConnect url: WCURL) {
        
    }

    func client(_: Client, didConnect session: Session) {
        self.session = session
        let sessionData = try! JSONEncoder().encode(session)
        UserDefaults.standard.set(sessionData, forKey: sessionKey)
        delegate.didConnect()
        isConnecting = true
    }

    func client(_: Client, didDisconnect _: Session) {
        UserDefaults.standard.removeObject(forKey: sessionKey)
        delegate.didDisconnect()
        isConnecting = false
    }
    
    func client(_ client: Client, didUpdate session: Session) {
        
    }

//    func client(_ client: Client, didReciveAliceSocket request: Request) {
//        guard let walletConnect = WCClientHelper.shared.walletConnect,
//            let client = walletConnect.client else {
//            return
//        }
//
//        do {
//            let message = try request.parameter(of: String.self, at: 0)
//            CallRNModule.walletConnectEvent(rawData: message)
//        } catch {
//            HUDManager.shared.showError(text: "Handle message failed")
//        }
//    }
}
