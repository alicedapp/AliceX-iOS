//
//  TransactionManager+Gas.swift
//  AliceX
//
//  Created by lmcmz on 18/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import BigInt
import Foundation
import PromiseKit
import web3swift

private let defaultGasLimitForTransaction = 100_000
private let defaultGasLimitForTokenTransfer = 100_000

extension TransactionManager {
    // Return GWEI
    func gasForSendingEth(to address: String, amount: BigUInt, data: Data) -> Promise<BigUInt> {
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

            let walletAddress = EthereumAddress(WalletManager.currentAccount!.address)!
            guard let contract = WalletManager.web3Net.contract(contractABI, at: toAddress, abiVersion: 2) else {
                seal.reject(WalletError.contractFailure)
                return
            }
            let value = amount
            var options = TransactionOptions.defaultOptions
            options.value = value
            options.from = walletAddress
            options.to = toAddress
            options.gasLimit = .automatic
            options.gasPrice = .automatic

            guard let tx = contract.write(
                methodName,
                parameters: methodParams,
                extraData: data,
                transactionOptions: options
            ) else {
                seal.reject(WalletError.contractFailure)
                return
            }

            tx.estimateGasPromise().done { value in
                seal.fulfill(value)
            }.catch { error in
                print(error.localizedDescription)
                seal.reject(error)
            }
        }
    }
}
