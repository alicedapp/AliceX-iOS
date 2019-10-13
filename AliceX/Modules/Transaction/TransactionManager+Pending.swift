//
//  TransactionManager+Pending.swift
//  AliceX
//
//  Created by lmcmz on 11/9/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import web3swift
import PromiseKit

private var fetchPendingFrequency: TimeInterval = 5.0

class PendingTransactionHelper {
    
    static let shared = PendingTransactionHelper()
    
    var pendingTxList: Set<PinItem> = Set<PinItem>()
    var timer: Timer!
    
    func start() {
        
        if timer != nil {
           timer.invalidate()
           timer = nil
       }
        
        timer = Timer(timeInterval: fetchPendingFrequency, target: self, selector: #selector(fetchStatus), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .default)
        timer.fire()
    }
    
    func stop() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
    
    @objc func fetchStatus() {
        print("Fetching pending tx status...")
        
        if pendingTxList.count == 0 {
            stop()
            return
        }

        // Support
        for item in pendingTxList {
            // TODO:
            // Replace with restful request
            
            firstly {
                fetchSingleTX(txHash: item.txHash, rpcURL: item.network.rpcURL.absoluteString)
            }.done { (receipt) in
                switch receipt.status {
                case .ok:
                    if !self.pendingTxList.contains(item) {
                        return
                    }
                    HUDManager.shared.showSuccess(text: "Transaction Confirmed")
                case .failed:
                    HUDManager.shared.showError(text: "Transaction Failed")
                    self.remove(item: item, isSuccess: false)
                case .notYetProcessed:
                    break
                }
            }
            
        }
    }
    
    func fetchSingleTX(txHash: String, rpcURL: String)
        -> Promise<TransactionReceipt> {
            
            return Promise<TransactionReceipt> { seal in
                
                firstly {
                    WalletManager.make(url: rpcURL)
                }.then { web3 in
                    web3.eth.getTransactionReceiptPromise(txHash)
                }.done { receipt in
                    seal.fulfill(receipt)
                }.catch { (error) in
                    seal.reject(error)
                }
            }
    }
    
    func add(item: PinItem) {
        pendingTxList.insert(item)
        postNotification(item: item, isNew: true, isSuccess: true)
        start()
    }
    
    func remove(item: PinItem, isSuccess: Bool) {
        pendingTxList.remove(item)
        postNotification(item: item, isNew: false, isSuccess: isSuccess)
    }
    
    func postNotification(item: PinItem, isNew: Bool, isSuccess: Bool) {
        if isNew {
            NotificationCenter.default.post(name: .newPendingTransaction, object: nil, userInfo: ["item": item])
        } else {
            NotificationCenter.default.post(name: .removePendingTransaction, object: nil, userInfo: ["item": item, "isSuccess": isSuccess])
        }
    }
    
}
