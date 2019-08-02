//
//  WalletCconnectHelper.swift
//  AliceX
//
//  Created by lmcmz on 31/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import WalletConnect
import web3swift

class WalletCconnectHelper {
    static let shared = WalletCconnectHelper()

    var interactor: WCInteractor?
    let clientMeta = WCPeerMeta(name: "WalletConnect SDK",
                                url: "https://github.com/alicedapp/wallet-connect-swift")
    var defaultAddress: String = WalletManager.wallet!.address
    var defaultChainId: Int = Web3Net.currentNetwork.chainID

    func fromQRCode(scanString: String) {
        guard let session = WCSession.from(string: scanString) else {
            print("WC: invalid url")
            return
        }
        connect(session: session)
    }

    func connect(session: WCSession) {
        print("==> session", session)
        let interactor = WCInteractor(session: session, meta: clientMeta)

        configure(interactor: interactor)

        interactor.connect().done { [weak self] connected in
            self?.connectionStatusUpdated(connected)
        }.cauterize()

        self.interactor = interactor
    }

    func configure(interactor: WCInteractor) {
        let accounts = [defaultAddress]
        let chainId = defaultChainId

        interactor.onSessionRequest = { [weak self] _, peer in
            let message = [peer.description, peer.url].joined(separator: "\n")
//            let alert = UIAlertController(title: peer.name, message: message, preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Reject", style: .destructive, handler: { _ in
//                self?.interactor?.rejectSession().cauterize()
//            }))
//            alert.addAction(UIAlertAction(title: "Approve", style: .default, handler: { _ in
//                self?.interactor?.approveSession(accounts: accounts, chainId: chainId).cauterize()
//            }))
//
//            let topVC = UIApplication.topViewController()
//            topVC?.show(alert, sender: nil)

            let view = BaseAlertView.instanceFromNib(title: peer.name,
                                                     content: message,
                                                     comfirmText: "Approve",
                                                     cancelText: "Reject",
                                                     comfirmBlock: {
                                                         self?.interactor?.approveSession(accounts: accounts, chainId: chainId).cauterize()
            }) {
                self?.interactor?.rejectSession().cauterize()
            }
            HUDManager.shared.showAlertView(view: view,
                                            backgroundColor: .clear,
                                            haptic: .none,
                                            type: .centerFloat)
//            HUDManager.shared.showAlert
        }

        interactor.onDisconnect = { [weak self] _ in
            self?.connectionStatusUpdated(false)
        }

        interactor.onEthSign = { [weak self] id, params in
            let alert = UIAlertController(title: "eth_sign", message: params[1], preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
            alert.addAction(UIAlertAction(title: "Sign", style: .default, handler: { _ in
                self?.signEth(id: id, message: params[1])
            }))
            let topVC = UIApplication.topViewController()
            topVC?.show(alert, sender: nil)
        }

        interactor.onEthSendTransaction = { [weak self] id, transaction in
            let data = try! JSONEncoder().encode(transaction)
            let message = String(data: data, encoding: .utf8)
            let alert = UIAlertController(title: "eth_sendTransaction", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Reject", style: .destructive, handler: { _ in
                self?.interactor?.rejectRequest(id: id, message: "I don't have ethers").cauterize()
            }))
            let topVC = UIApplication.topViewController()
            topVC?.show(alert, sender: nil)
        }

        interactor.onBnbSign = { [weak self] id, order in
            let message = order.encodedString
            let alert = UIAlertController(title: "bnb_sign", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
            alert.addAction(UIAlertAction(title: "Sign", style: .default, handler: { [weak self] _ in
                self?.signBnbOrder(id: id, order: order)
            }))
            let topVC = UIApplication.topViewController()
            topVC?.show(alert, sender: nil)
        }
    }

    func approve(accounts _: [String], chainId _: Int) {
//        interactor?.approveSession(accounts: accounts, chainId: chainId).done {
//            print("<== approveSession done")
//        }.cauterize()
    }

    func signEth(id _: Int64, message _: String) {
//        guard let data = message.data(using: .utf8) else {
//            print("invalid message")
//            return
//        }
//        let prefix = "\u{19}Ethereum Signed Message:\n\(data.count)"
//        let finalMessage = "\(prefix)\(message)"
//        var result = TransactionManager.signMessage(message: Data.fromHex(finalMessage)!)
//        result[64] += 27
//        self.interactor?.approveRequest(id: id, result: result.hexString).cauterize()
    }

    func signBnbOrder(id _: Int64, order _: WCBinanceOrder) {
//        let data = order.encoded
//        print("==> signbnbOrder", String(data: data, encoding: .utf8)!)
//        let signature = privateKey.sign(digest: Hash.sha256(data: data), curve: .secp256k1)!
//        let signed = WCBinanceOrderSignature(
//            signature: signature.dropLast().hexString,
//            publicKey: privateKey.getPublicKeySecp256k1(compressed: false).data.hexString
//        )
//        interactor?.approveBnbOrder(id: id, signed: signed).done({ confirm in
//            print("<== approveBnbOrder", confirm)
//        }).cauterize()
    }

    func connectionStatusUpdated(_: Bool) {
//        self.approveButton.isEnabled = connected
//        self.connectButton.setTitle(!connected ? "Connect" : "Disconnect", for: .normal)
    }

//    @IBAction func connectTapped() {
//        guard let string = uriField.text, let session = WCSession.from(string: string) else {
//            print("invalid uri: \(String(describing: uriField.text))")
//            return
//        }
//        if let i = interactor, i.connected {
//            i.killSession().done {  [weak self] in
//                self?.approveButton.isEnabled = false
//                self?.connectButton.setTitle("Connect", for: .normal)
//            }.cauterize()
//        } else {
//            connect(session: session)
//        }
//    }

//    @IBAction func approveTapped() {
//        guard let address = addressField.text,
//            let chainIdString = chainIdField.text else {
//                print("empty address or chainId")
//                return
//        }
//        guard let chainId = Int(chainIdString) else {
//            print("invalid chainId")
//            return
//        }
//        guard let address = EthereumAddress(address) else {
//            print("invalid eth or bnb address")
//            return
//        }
//        approve(accounts: [address], chainId: chainId)
//    }
}
