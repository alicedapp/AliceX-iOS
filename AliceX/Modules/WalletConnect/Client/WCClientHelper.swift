//
//  WalletConnectClientHelper.swift
//  AliceX
//
//  Created by lmcmz on 24/9/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import WalletConnectSwift
import web3swift
import BonMot

// TODO: Complete it
class WCClientHelper {
    static let shared = WCClientHelper()
    
    var walletConnect: WCClient?
    var urlString: String!
    var connectedDate: Date?
    
    var showDisAlert: Bool = true
//    lazy var clientInfo = {
//        return walletConnect.session.walletInfo?.peerMeta
//    }()
    
    init() {
//        walletConnect.reconnectIfNeeded()
    }
    
    func create() {
        
        if let walletConnect = self.walletConnect{
            if walletConnect.isConnecting {
                
                onMainThread {
                    let view = BaseAlertView.instanceFromNib(content: "Do you wanna disconnect current session?",
                                                  confirmBlock: {
                                                    self.disconnect()
                                                    self.urlString = self.walletConnect?.connect()
                                                    self.showQRCode()
                    }) {
                        HUDManager.shared.dismiss()
                    }
                    HUDManager.shared.showAlertView(view: view, backgroundColor: .clear, haptic: .none,
                                                    type: .centerFloat, widthIsFull: false, canDismiss: true)
                }

                return
            }
        }
        
        self.walletConnect = WCClient(delegate: self)
        self.urlString = self.walletConnect?.connect()
        self.showQRCode()
        
    }
    
    func showQRCode() {
        onMainThread {
            let vc = WCQRCodeViewController.make(url: self.urlString)
            HUDManager.shared.showAlertVCNoBackground(viewController: vc)
        }
    }
    
    func disconnect() {
        guard let walletConnect = self.walletConnect ,
            let session = walletConnect.session,
            let client = walletConnect.client else {
            return
        }
        do {
            try client.disconnect(from: session)
        } catch {
            // TODO
        }
    }
    
    func disconnect(key: String) {
        guard let walletConnect = self.walletConnect,
            let session = walletConnect.session else {
                return
        }
        if session.url.key == key {
            disconnect()
        }
    }
}

extension WCClientHelper: WCClientDelegate {
    
    func failedToConnect() {
        HUDManager.shared.showError(text: "Failed to connect")
    }
    
    func didConnect() {
        
        onMainThread {
            NotificationCenter.default.post(name: .wallectConnectClientConnect, object: nil)
            HUDManager.shared.showSuccess(text: "Connected")
            let dappInfo = self.walletConnect?.session.walletInfo?.peerMeta
            let image = dappInfo?.icons.first ?? URL(string: "https://blobscdn.gitbook.com/v0/b/gitbook-28427.appspot.com/o/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?generation=1545143197857624&alt=media")!
            
            let vc = WCControlPanel()
            let pinItem = PinItem.walletConnect(image: image,
                                                id: self.walletConnect!.session.url.key,
                                                title: "WC: \(String(describing: dappInfo!.url.host!))", viewcontroller: vc)
            PinManager.shared.addPinItem(item: pinItem)
            self.connectedDate = Date()
        }
    }
    
    func didDisconnect() {
        let dict = ["key": walletConnect?.session.url.key]
        NotificationCenter.default.post(name: .wallectConnectClientDisconnect, object: nil, userInfo: dict)
        if showDisAlert {
            HUDManager.shared.showErrorAlert(text: "Wallect Connect Disconect", isAlert: true)
        } else {
            HUDManager.shared.showError(text: "Wallect Connect Disconect")
        }
        walletConnect = nil
        self.connectedDate = nil
    }
    
}
