//
//  ContractModule.swift
//  AliceX
//
//  Created by lmcmz on 26/6/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation

@objc(ContractModule)
class ContractModule: NSObject {
    
    @objc func write(_ contractAddress: String, abi: String,
                     functionName: String,
                     parameters: [Any],
                     value: String,
                     data: String,
                     callback successCallback: @escaping RCTResponseSenderBlock) {
        
        DispatchQueue.main.async {
            
            TransactionManager.showContractWriteView(contractAddress: contractAddress,
                                                     functionName: functionName,
                                                     abi: abi,
                                                     parameters: parameters,
                                                     value: value,
                                                     extraData: data) { (txHash) in
                    successCallback([txHash])
            }
        }
    }
    
    @objc func read(_ contractAddress: String, abi: String, functionName: String, parameters: [Any],
                    callback successCallback: @escaping RCTResponseSenderBlock) {
        
        DispatchQueue.main.async {
            do {
                let tx = try TransactionManager.readSmartContract(contractAddress: contractAddress,
                                                                  functionName: functionName,
                                                                  abi: abi,
                                                                  parameters: parameters)
                successCallback([tx])
            } catch {
                print(error)
                successCallback([error])
            }
        }
    }
}
