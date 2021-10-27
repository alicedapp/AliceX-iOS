//
//  WalletCoreManager+Binance.swift
//  AliceX
//
//  Created by lmcmz on 15/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import BigInt
import Foundation
import PromiseKit
import WalletCore

extension WalletCore {
    func binanceAccountInfo(address: String) -> Promise<BinanceAccount> {
        return Promise<BinanceAccount> { seal in
            firstly { () -> Promise<BinanceAccount> in
                API(BNBAPI.account(address: address))
            }.done { info in
                seal.fulfill(info)
            }.catch { error in
                seal.reject(error)
            }
        }
    }

    func binanceNodeInfo() -> Promise<BinanceNodeInfo> {
        return Promise<BinanceNodeInfo> { seal in
            firstly { () -> Promise<BinanceNodeInfo> in
                API(BNBAPI.nodeInfo, path: "node_info")
            }.done { info in
                seal.fulfill(info)
            }.catch { error in
                seal.reject(error)
            }
        }
    }

    func binanceTransaction(node: BinanceNodeInfo, account: BinanceAccount, toAddress: String, amount: BigUInt) -> Promise<BinanceResult> {
        return Promise<BinanceResult> { seal in

            guard let toAddress = AnyAddress(string: toAddress, coin: .binance) else {
                throw WalletError.invalidAddress
            }

            let key = WalletCore.wallet.getKeyForCoin(coin: .binance)
            let publicKey = key.getPublicKeySecp256k1(compressed: true)
            var signingInput = TW_Binance_Proto_SigningInput()
            signingInput.chainID = node.network
            signingInput.accountNumber = account.account_number
            signingInput.sequence = account.sequence
            signingInput.privateKey = key.data

            var token = TW_Binance_Proto_SendOrder.Token()
            token.denom = "BNB"
            token.amount = Int64(amount)

            var input = TW_Binance_Proto_SendOrder.Input()
            input.address = AnyAddress(publicKey: publicKey, coin: .binance).data
            input.coins = [token]

            var output = TW_Binance_Proto_SendOrder.Output()
            output.address = toAddress.data
            output.coins = [token]

            var sendOrder = TW_Binance_Proto_SendOrder()
            sendOrder.inputs = [input]
            sendOrder.outputs = [output]

            signingInput.sendOrder = sendOrder
            
            let data: BinanceSigningOutput = AnySigner.sign(input: input, coin: .binance)

            BNBProvider.request(.broadcast(data: data.encoded.hexdata)) { result in
                switch result {
                case let .success(response):

                    if let errorModel = response.mapObject(BinanceErrorResult.self) {
                        seal.reject(WalletError.custom(errorModel.message))
                        return
                    }

                    guard let modelArray = response.mapArray(BinanceResult.self) else {
                        seal.reject(MyError.DecodeFailed)
                        return
                    }

                    guard let txResult = modelArray.first, let finalResult = txResult else {
                        seal.reject(MyError.FoundNil("Nil result"))
                        return
                    }

                    seal.fulfill(finalResult)

                case let .failure(error):
                    seal.reject(error)
                }
            }
        }
    }

    func binanceSend(toAddress: String, value: BigUInt) -> Promise<String> {
        return Promise<String> { seal in

            let address = WalletCore.address(blockchain: .Binance)

            firstly {
                when(fulfilled: binanceNodeInfo(), binanceAccountInfo(address: address))
            }.then { (node, account) -> Promise<BinanceResult> in
                self.binanceTransaction(node: node, account: account, toAddress: toAddress, amount: value)
            }.done { result in
                seal.fulfill(result.hash)

                let url = BlockChain.Binance.txURL(txHash: result.hash)
                let browser = BrowserWrapperViewController.make(urlString: url.absoluteString)

                let pinItem = PinItem.transaction(coin: Coin.coin(chain: .Binance),
                                                  network: WalletManager.currentNetwork,
                                                  txHash: result.hash,
                                                  title: "Pending BNB",
                                                  viewcontroller: browser)
//                PendingTransactionHelper.shared.add(item: pinItem)
                PinManager.shared.addPinItem(item: pinItem)
            }.catch { error in
                seal.reject(error)
            }
        }
    }
}
