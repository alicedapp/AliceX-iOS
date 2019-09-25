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
    
    var server: Server!
    var session: Session?
    
    lazy var dappInfo = {
        return session?.dAppInfo.peerMeta
    }()
    
    init() {
        server = Server(delegate: self)
        server.register(handler: SignTransactionHandler(server: server))
        server.register(handler: PersonalSignHandler(server: server))
        server.register(handler: SendTransactionHandler(server: server))
//        server.register(handler: SignHandler(server: server))
    }
    
    func connect(url: String) {
        guard let url = WCURL(url) else { return }
        do {
            try self.server.connect(to: url)
        } catch {
            HUDManager.shared.showError(text: "Parse Wallet Connect QRcode failed")
        }
    }
    
    func disconnect() {
        
        guard let session = self.session else { return }
        
        do {
            try server.disconnect(from: session)
        } catch {
            HUDManager.shared.showError(text: "Disconnect Wallect Failed")
        }
        
    }
}

extension WCServerHelper: ServerDelegate {
    
    func server(_ server: Server, didFailToConnect url: WCURL) {
        HUDManager.shared.showErrorAlert(text: "Wallect Connect Faild to Connect")
    }
    
    func server(_ server: Server, shouldStart session: Session, completion: @escaping (Session.WalletInfo) -> Void) {
        
        let aliceLogo = URL(string: "https://static1.squarespace.com/static/5c62768baf4683e94383848a/t/5ceca03be2c4834cdc18a838/1568564936191/?format=1500w")!
        
        let walletMeta = Session.ClientMeta(name: "Alice Wallet",
                                            description: "Alice Wallet Connect",
                                            icons: [aliceLogo],
                                            url: URL(string: "https://www.alicedapp.com")!)
        
        let walletInfo = Session.WalletInfo(approved: true,
                                            accounts: [WalletManager.wallet!.address],
                                            chainId: WalletManager.currentNetwork.chainID,
                                            peerId: UUID().uuidString,
                                            peerMeta: walletMeta)
        
        let portAName = session.dAppInfo.peerMeta.name
        let portAImage = session.dAppInfo.peerMeta.icons.first
        
        self.session = session
        
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
    
    func server(_ server: Server, didConnect session: Session) {
        
    }
    
    func server(_ server: Server, didDisconnect session: Session) {
        HUDManager.shared.showErrorAlert(text: "Wallect Connect Disconnect", isAlert: true)
    }
    
}
