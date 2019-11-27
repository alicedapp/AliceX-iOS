//
//  Blockchain+NetworkLayer.swift
//  AliceX
//
//  Created by lmcmz on 5/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import BigInt
import Foundation
import PromiseKit
import web3swift

extension BlockChain: NetworkLayer {
    func getBalance() -> Promise<BigUInt> {
        return Promise<BigUInt> { seal in
            switch self {
            case .Ethereum:
                guard let address = WalletManager.wallet?.address else {
                    seal.reject(WalletError.accountDoesNotExist)
                    return
                }
                guard let ethereumAddress = EthereumAddress(address) else {
                    seal.reject(WalletError.invalidAddress)
                    return
                }
                firstly {
                    WalletManager.web3Net.eth.getBalancePromise(address: ethereumAddress)
                }.done { balanceStr in
                    seal.fulfill(balanceStr)
                }.catch { error in
                    seal.reject(error)
                }
            case .Bitcoin:
                firstly { () -> Promise<AmberdataBalance> in
                    API(AmberData.accountBalance(address: WalletCore.address(blockchain: self), blockchain: self), path: "payload")
                }.done { model in
                    seal.fulfill(BigUInt(model.value) as! BigUInt)
                }.catch { _ in
//                    seal.reject(error)
                    seal.fulfill(BigUInt(0))
                }
            case .Binance:
                firstly { () -> Promise<BinanceAccount> in
                    API(BNBAPI.account(address: WalletCore.address(blockchain: self)))
                }.done { model in

                    let balances = model.balances.filter { $0.symbol == "BNB" }
                    guard let balance = balances.first else {
                        throw MyError.FoundNil("Can't find BNB in API")
                    }

                    let balanceDouble = Double(balance.free)! * pow(Double(10), Double(self.decimal))

                    seal.fulfill(BigUInt(balanceDouble) as! BigUInt)

                }.catch { _ in
//                    seal.reject(error)
                    seal.fulfill(BigUInt(0))
                }
            default:
                seal.fulfill(0)
            }
        }
    }

    func transfer(toAddress: String, value: BigUInt, data: Data = Data(),
                  gasPrice: GasPrice = GasPrice.average,
                  gasLimit: TransactionOptions.GasLimitPolicy = .automatic) -> Promise<String> {
        return Promise<String> { seal in

            var method: Promise<String>?
            switch self {
            case .Ethereum:
                method = TransactionManager.shared.sendEtherSync(to: toAddress, amount: value,
                                                                 data: data,
                                                                 gasPrice: gasPrice,
                                                                 gasLimit: gasLimit)
            case .Binance:
                method = WalletCore.shared.binanceSend(toAddress: toAddress, value: value)

            default:
                break
            }

            guard let block = method else {
                throw MyError.FoundNil("No tranfer method find")
            }

            block.done { txHash in
                seal.fulfill(txHash)
            }.catch { error in
                seal.reject(error)
            }
        }
    }
}
