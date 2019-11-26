//
//  WalletConnectServerHandler.swift
//  AliceX
//
//  Created by lmcmz on 24/9/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import BigInt
import Foundation
import WalletConnectSwift
import web3swift

class WCHandler: RequestHandler {
    weak var server: Server!

    struct WCTransaction: Codable {
        var from: String
        var to: String?
        var data: String
        var gasLimit: String?
        var gasPrice: String?
        var value: String?
        var nonce: String?
    }

    init(server: Server) {
        self.server = server
    }

    func canHandle(request _: Request) -> Bool {
        return false
    }

    func handle(request _: Request) {
        // to override
    }
}

class SignTransactionHandler: WCHandler {
    override func canHandle(request: Request) -> Bool {
        return request.method == "eth_signTransaction"
    }

    override func handle(request: Request) {
        onMainThread {
            let info = WCServerHelper.shared.session?.dAppInfo.peerMeta
            let name = info?.url.host ?? "Dapp"

            let view = WCPopUp.make(logo: info?.icons.first,
                                    name: info?.name ?? "Dapp",
                                    title: "Request To Sign Transaction",
                                    content: "<alice>Alice</alice> received a request from <blue>\(name)</blue>, if that is not your operation.\nPlease <red>reject</red> it.",
                                    comfirmBlock: {
                                        self.signTx(request: request)
            }) {
                self.server.send(.reject(request))
            }

            HUDManager.shared.showAlertView(view: view,
                                            backgroundColor: .clear,
                                            haptic: .none,
                                            type: .bottomFloat,
                                            widthIsFull: true,
                                            canDismiss: false)
        }
    }

    func signTx(request: Request) {
        do {
            let wcTx = try request.parameter(of: WCTransaction.self, at: 0)

            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(wcTx)
            let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)
            guard let transactionJSON = jsonString?.toJSON() as? [String: Any] else {
                throw WalletError.custom("Parse tx failed")
            }

            guard let tx = EthereumTransaction.fromJSON(transactionJSON) else {
                throw WalletError.custom("Parse tx failed")
            }

            guard let options = TransactionOptions.fromJSON(transactionJSON) else {
                throw WalletError.custom("Parse tx failed")
            }

            let value = options.value != nil ? options.value! : BigUInt(0)

            TransactionManager.showSignTransactionView(to: tx.to.address, value: value, data: tx.data) { signData in
                let response = try! Response(url: request.url, value: signData, id: request.id!)
                self.server.send(response)
//                HUDManager.shared.dismiss()
            }
        } catch {
            server.send(.invalid(request))
            HUDManager.shared.showError(text: "Handle Wallect Connect Request Faild")
            return
        }
    }
}

class SendTransactionHandler: WCHandler {
    override func canHandle(request: Request) -> Bool {
        return request.method == "eth_sendTransaction"
    }

    override func handle(request: Request) {
        onMainThread {
            let info = WCServerHelper.shared.session?.dAppInfo.peerMeta
            let name = info?.url.host ?? "Dapp"

            let view = WCPopUp.make(logo: info?.icons.first,
                                    name: info?.name ?? "Dapp",
                                    title: "Request To Send Transaction",
                                    content: "<alice>Alice</alice> received a request from <blue>\(name)</blue>, if that is not your operation.\nPlease <red>reject</red> it.",
                                    comfirmBlock: {
                                        self.sendTx(request: request)
            }) {
                self.server.send(.reject(request))
            }

            HUDManager.shared.showAlertView(view: view,
                                            backgroundColor: .clear,
                                            haptic: .none,
                                            type: .bottomFloat,
                                            widthIsFull: true,
                                            canDismiss: false)
        }
    }

    func sendTx(request: Request) {
        do {
            let wcTx = try request.parameter(of: WCTransaction.self, at: 0)

            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(wcTx)
            let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)
            guard let json = jsonString, let transactionJSON = json.toJSON() as? [String: Any] else {
                throw WalletError.custom("Parse tx failed")
            }

            guard let tx = EthereumTransaction.fromJSON(transactionJSON) else {
                throw WalletError.custom("Parse tx failed")
            }

            guard let options = TransactionOptions.fromJSON(transactionJSON) else {
                throw WalletError.custom("Parse tx failed")
            }

            let value = options.value != nil ? options.value! : BigUInt(0)

            TransactionManager.showPaymentView(toAddress: tx.to.address,
                                               amount: value,
                                               data: tx.data,
                                               coin: Coin.coin(chain: .Ethereum)) { signData in
                let response = try! Response(url: request.url, value: signData, id: request.id!)
                self.server.send(response)
//                HUDManager.shared.dismiss()
            }
        } catch let error {
            server.send(.invalid(request))
//            HUDManager.shared.showError(text: "Handle Wallect Connect Request Faild")
            HUDManager.shared.showError(error: error)
            return
        }
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
                server.send(.reject(request))
                HUDManager.shared.showError(text: "Address Not Matched")
                return
            }

            guard let decodedMessage = messageBytes.hexDecodeUTF8 else {
                server.send(.reject(request))
                HUDManager.shared.showError(text: "Message decode failed")
                return
            }

            onMainThread {
                let info = WCServerHelper.shared.session?.dAppInfo.peerMeta
                let name = info?.url.host ?? "Dapp"
                let view = WCPopUp.make(logo: info?.icons.first,
                                        name: info?.name ?? "Dapp",
                                        title: "Request To Sign Message",
                                        content: "<alice>Alice</alice> received a request from <blue>\(name)</blue>, if that is not your operation.\nPlease <red>reject</red> it.",
                                        comfirmBlock: {
                                            self.signMessage(request: request, message: messageBytes)
                }) {
                    self.server.send(.reject(request))
                }

                HUDManager.shared.showAlertView(view: view,
                                                backgroundColor: .clear,
                                                haptic: .none,
                                                type: .bottomFloat,
                                                widthIsFull: true,
                                                canDismiss: false)
            }

//            let signed = try TransactionManager.signMessage(message: Data.fromHex(messageBytes)!)
        } catch {
            server.send(.invalid(request))
            return
        }
    }

    func signMessage(request: Request, message: String) {
        TransactionManager.showSignMessageView(message: message) { signed in
            let response = try! Response(url: request.url, value: signed, id: request.id!)
            self.server.send(response)
        }
    }
}

// class SignHandler: WCHandler {
//
//    override func canHandle(request: Request) -> Bool {
//        return request.method == "eth_sign"
//    }
//
//    override func handle(request: Request) {
//        do {
//
//            var messageBytes = try request.parameter(of: String.self, at: 0)
//            var address = try request.parameter(of: String.self, at: 1)
//
//            // TODO: Change way to mach
//            if address.count != 42 {
//                swap(&address, &messageBytes)
//            }
//
//            if address.lowercased() != WalletManager.wallet?.address.lowercased() {
//               server.send(.reject(request))
//                HUDManager.shared.showError(text: "Address Not Matched")
//               return
//           }
//
////            guard let decodedMessage = messageBytes.hexDecodeUTF8 else {
////                server.send(.reject(request))
////                HUDManager.shared.showError(text: "Message decode failed")
////                return
////            }
//
//            onMainThread {
//
//                let info = WCServerHelper.shared.dappInfo
//
//                let name = info?.url.host ?? "Dapp"
//
//                let view = WCPopUp.make(logo: info?.icons.first,
//                                        name: info?.name ?? "Dapp",
//                                        title: "Request To Sign Message",
//                                        content: "<alice>Alice</alice> received a request from <blue>\(name)</blue>, if that is not your operation.\nPlease <red>reject</red> it.",
//                                        comfirmBlock: {
//                                            self.signMessage(request: request, message: messageBytes)
//                }) {
//                    self.server.send(.reject(request))
//                }
//
//               HUDManager.shared.showAlertView(view: view,
//                                               backgroundColor: .clear,
//                                               haptic: .none,
//                                               type: .bottomFloat,
//                                               widthIsFull: true,
//                                               canDismiss: false)
//            }
//
////            let signed = try TransactionManager.signMessage(message: Data.fromHex(messageBytes)!)
//       } catch {
//           server.send(.invalid(request))
//           return
//       }
//    }
//
//    func signMessage(request: Request, message: String) {
//        TransactionManager.showSignMessageView(message: message) { (signed) in
//            let response = try! Response(url: request.url, value: signed, id: request.id!)
//            self.server.send(response)
//        }
//    }
// }
