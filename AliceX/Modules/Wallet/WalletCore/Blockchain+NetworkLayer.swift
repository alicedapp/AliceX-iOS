//
//  Blockchain+NetworkLayer.swift
//  AliceX
//
//  Created by lmcmz on 5/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import PromiseKit
import BigInt
import web3swift

extension BlockChain: NetworkLayer {
    
//    func getBalance() -> Promise<Double> {
//        return Promise<Double> { seal in
//            switch self {
//            case .Ethereum:
//                firstly {
//                    TransactionManager.shared.etherBalance()
//                }.done { balanceStr in
//                    seal.fulfill(Double(balanceStr)!)
//                }.catch { (error) in
//                    seal.reject(error)
//                }
//            case .Bitcoin:
//                firstly { () -> Promise<AmberdataBalance> in
//                    API(AmberData.accountBalance(address: WalletCore.shared.address(blockchain: self), blockchain: self), path: "payload")
//                }.done { model in
//                    seal.fulfill(Double(model.value)!)
//                }.catch { (error) in
//                    seal.reject(error)
//                }
//            default:
//                seal.fulfill(0)
//            }
//        }
//    }
    
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
                }.catch { (error) in
                    seal.reject(error)
                }
            case .Bitcoin:
                firstly { () -> Promise<AmberdataBalance> in
                    API(AmberData.accountBalance(address: WalletCore.shared.address(blockchain: self), blockchain: self), path: "payload")
                }.done { model in
                    seal.fulfill(BigUInt(model.value) as! BigUInt)
                }.catch { (error) in
//                    seal.reject(error)
                    seal.fulfill(BigUInt(0))
                }
            case .Binance:
                firstly { () -> Promise<BinanceAccount> in
                    API(BNBAPI.account(address: WalletCore.shared.address(blockchain: self)))
                }.done { model in
                    
                    let balances = model.balances.filter { $0.symbol == "BNB" }
                    guard let balance = balances.first else {
                        throw MyError.FoundNil("Can't find BNB in API")
                    }
                    
                    let balanceDouble = Double(balance.free)! * pow(Double(10), Double(self.decimal))

                    seal.fulfill(BigUInt(balanceDouble) as! BigUInt)
                    
                }.catch { (error) in
//                    seal.reject(error)
                    seal.fulfill(BigUInt(0))
                }
            default:
                seal.fulfill(0)
            }
        }
    }
}
