//
//  WalletCconnectHelper.swift
//  AliceX
//
//  Created by lmcmz on 31/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import BigInt
import Foundation
import WalletConnectSwift
import web3swift

class WCServerHelper {
    static let shared = WCServerHelper()

    var server: Server?
    var session: Session?
    var isConnecting: Bool = false
    var connectedDate: Date?

//    var dappInfo = {
//        return session?.dAppInfo.peerMeta
//    }()

//    typealias dappaInfo = session?.dAppInfo.peerMeta

    init() {
//        server.register(handler: SignHandler(server: server))
    }

    func connect(url: String) {
        if isConnecting, session != nil {
            disconnect()
        }

        server = Server(delegate: self)
        server!.register(handler: SignTransactionHandler(server: server!))
        server!.register(handler: PersonalSignHandler(server: server!))
        server!.register(handler: SendTransactionHandler(server: server!))
        server!.register(handler: WCCustomHandler(server: server!))

        guard let url = WCURL(url) else { return }
        do {
            try server!.connect(to: url)
        } catch {
            HUDManager.shared.showError(text: "Parse Wallet Connect QRcode failed")
        }
    }

    func disconnect() {
        guard let session = self.session, let server = self.server else { return }

        do {
            try server.disconnect(from: session)
        } catch {
            HUDManager.shared.showError(text: "Disconnect Wallet Failed")
        }
    }

    func disconnect(key: String) {
        guard let session = self.session else { return }
        if session.url.key == key {
            disconnect()
        }
    }
}

extension WCServerHelper: ServerDelegate {
    func server(_: Server, didFailToConnect _: WCURL) {
        HUDManager.shared.showErrorAlert(text: "Wallect Connect Faild to Connect")
    }

    func server(_: Server, shouldStart session: Session, completion: @escaping (Session.WalletInfo) -> Void) {
        let aliceLogo = URL(string: "https://static1.squarespace.com/static/5c62768baf4683e94383848a/t/5ceca03be2c4834cdc18a838/1568564936191/?format=1500w")!

        let walletMeta = Session.ClientMeta(name: "Alice",
                                            description: "Alice Wallet Connect",
                                            icons: [aliceLogo],
                                            url: URL(string: "https://www.alicedapp.com")!)

        let walletInfo = Session.WalletInfo(approved: true,
                                            accounts: [WalletManager.currentAccount!.address],
                                            chainId: WalletManager.currentNetwork.chainID,
                                            peerId: UUID().uuidString,
                                            peerMeta: walletMeta)

        let portAName = session.dAppInfo.peerMeta.name
        let portAImage = session.dAppInfo.peerMeta.icons.first

        self.session = session
        self.session?.walletInfo = walletInfo

        onMainThread {
            let view = WCConnectPopup.make(portAImage: portAImage, portAName: portAName,
                                           portBImage: aliceLogo, portBName: "Alice",
                                           comfirmBlock: {
                                               completion(walletInfo)
            }) {
                completion(Session.WalletInfo(approved: false, accounts: [], chainId: WalletManager.currentNetwork.chainID, peerId: "", peerMeta: walletMeta))
            }

            HUDManager.shared.showAlertView(view: view,
                                            backgroundColor: .clear,
                                            haptic: .none,
                                            type: .bottomFloat,
                                            widthIsFull: true,
                                            canDismiss: false)
        }
    }

    func server(_: Server, didConnect session: Session) {
        onMainThread {
            NotificationCenter.default.post(name: .wallectConnectServerConnect, object: nil)
            let dappInfo = session.dAppInfo.peerMeta
            let image = dappInfo.icons.first ?? URL(string: "https://blobscdn.gitbook.com/v0/b/gitbook-28427.appspot.com/o/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?generation=1545143197857624&alt=media")!

            let vc = WCControlPanel()
            let pinItem = PinItem.walletConnect(image: image, id: session.url.key,
                                                title: "WC: \(dappInfo.url.host!)", viewcontroller: vc)
            PinManager.shared.addPinItem(item: pinItem)
            self.isConnecting = true
            self.connectedDate = Date()
        }
    }

    func server(_: Server, didDisconnect session: Session) {
        let dict = ["key": session.url.key]
        NotificationCenter.default.post(name: .wallectConnectServerDisconnect, object: nil, userInfo: dict)
        HUDManager.shared.showErrorAlert(text: "Wallect Connect Disconnect", isAlert: true)
        isConnecting = false
        server = nil
        self.session = nil
        connectedDate = nil
    }
}
