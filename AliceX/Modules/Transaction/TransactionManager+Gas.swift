//
//  TransactionManager+Gas.swift
//  AliceX
//
//  Created by lmcmz on 18/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import web3swift
import BigInt
import PromiseKit

private let defaultGasLimitForTransaction = 100000
private let defaultGasLimitForTokenTransfer = 100000

extension TransactionManager {
    
    // Return GWEI
    func gasForSendingEth(to address: String, amount: BigUInt, data: Data) -> Promise<BigUInt> {
        
//        return Promise { seal in
//            guard let toAddress = EthereumAddress(address) else {
//                seal.reject(WalletError.accountDoesNotExist)
//                return
//            }
//
//            let walletAddress = EthereumAddress(WalletManager.wallet!.address)!
//            let contract = WalletManager.web3Net.contract(Web3.Utils.coldWalletABI, at: toAddress, abiVersion: 2)!
//            let value = Web3.Utils.parseToBigUInt(String(amount), units: .eth)
//            var options = TransactionOptions.defaultOptions
//            options.value = value
//            options.from = walletAddress
//
//            let tx = contract.write( "fallback",
//                                     parameters: [AnyObject](),
//                                     extraData: data,
//                                     transactionOptions: options)!
//
//            tx.estimateGasPromise().done { (value) in
//                seal.fulfill(value)
//            }.catch({ (error) in
//                print(error.localizedDescription)
//                seal.reject(error)
//            })
//        }
        
        return gasForContractMethod(to: address,
                                    contractABI: Web3.Utils.coldWalletABI,
                                    methodName: "fallback",
                                    methodParams: [],
                                    amount: amount,
                                    data: data)
    }
    
    func gasForContractMethod(to address: String,
                              contractABI: String,
                              methodName: String,
                              methodParams: [AnyObject],
                              amount: BigUInt,
                              data: Data) -> Promise<BigUInt> {
        return Promise { seal in
            guard let toAddress = EthereumAddress(address) else {
                seal.reject(WalletError.accountDoesNotExist)
                return
            }
            
            let walletAddress = EthereumAddress(WalletManager.wallet!.address)!
            let contract = WalletManager.web3Net.contract(contractABI, at: toAddress, abiVersion: 2)!
            let value = amount
            var options = TransactionOptions.defaultOptions
            options.value = value
            options.from = walletAddress
            options.to = toAddress
            
            let tx = contract.write( methodName,
                                     parameters: methodParams,
                                     extraData: data,
                                     transactionOptions: options)!
            
            tx.estimateGasPromise().done { (value) in
                seal.fulfill(value)
            }.catch({ (error) in
                print(error.localizedDescription)
                seal.reject(error)
            })
            
        }
    }
}
