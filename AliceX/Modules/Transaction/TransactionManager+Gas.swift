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
    func gasForSendingEth(to address: String, amount: String) -> Promise<BigUInt> {
        
        return Promise { seal in
            guard let toAddress = EthereumAddress(address) else {
                seal.reject(WalletError.accountDoesNotExist)
                return
            }
            
            let walletAddress = EthereumAddress(WalletManager.wallet!.address)!
            let contract = WalletManager.web3Net.contract(Web3.Utils.coldWalletABI, at: toAddress, abiVersion: 2)!
            let value = Web3.Utils.parseToBigUInt(amount, units: .eth)
            var options = TransactionOptions.defaultOptions
            options.value = value
            options.from = walletAddress
            
            let tx = contract.write( "fallback",
                                     parameters: [AnyObject](),
                                     extraData: Data(),
                                     transactionOptions: options)!
            
            tx.estimateGasPromise().done { (value) in
                seal.fulfill(value)
            }.catch({ (error) in
                print(error.localizedDescription)
                seal.reject(error)
            })
        }
    }
    
    func gasFeeForSendingEth(to address: String, amount: String) throws -> Float {
        return 0.0
    }
    
    func gasForContractMethod(contractAddress:String, methodName:String,
                              methodParams:[Any?], completion: @escaping(ContractError?, Int?, Int?) -> ())
    {
        
    }
    
    func currentGasEstimate(completion: @escaping(Int) -> ()) {
        
    }
}
