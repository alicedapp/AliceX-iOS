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
                     parameter: [Any],
                     value: String,
                     callback successCallback: @escaping RCTResponseSenderBlock) {
        
        DispatchQueue.main.async {
            do {
                let tx = try TransactionManager.writeSmartContract(contractAddress: contractAddress,
                                                                   functionName: functionName,
                                                                   abi: abi,
                                                                   parameter: parameter,
                                                                   value: value)
                successCallback([tx])
            } catch {
                print(error)
                successCallback([error])
            }
        }
    }
    
    @objc func read(_ contractAddress: String, abi: String, functionName: String, parameter: [Any],
                    callback successCallback: @escaping RCTResponseSenderBlock) {
        
        DispatchQueue.main.async {
            do {
                let tx = try TransactionManager.readSmartContract(contractAddress: contractAddress,
                                                                  functionName: functionName,
                                                                  abi: abi,
                                                                  parameter: parameter)
                successCallback([tx])
            } catch {
                print(error)
                successCallback([error])
            }
        }
    }
}
