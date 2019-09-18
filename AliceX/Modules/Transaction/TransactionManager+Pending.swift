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
            let web = try! WalletManager.make(type: item.network)
            firstly {
                 web.eth.getTransactionReceiptPromise(item.txHash)
            }.done { receipt in
                switch receipt.status {
                case .ok:
                    if !self.pendingTxList.contains(item) {
                        return
                    }
                    HUDManager.shared.showSuccess(text: "Transaction Confirmed")
                    self.remove(item: item)
                case .failed:
                    HUDManager.shared.showError(text: "Transaction Failed")
                    self.remove(item: item)
                case .notYetProcessed:
                    break
                }
            }
            
//            firstly { () -> Promise<TransactionReceipt> in
//                API(AmberData.getTransactions(hash: item.txHash, network: item.network))
//            }.done { receipt in
//                switch receipt.status {
//                case .ok:
//                    HUDManager.shared.showSuccess(text: "Transaction Confirmed")
//                    self.remove(item: item)
//                case .failed:
//                    HUDManager.shared.showError(text: "Transaction Failed")
//                    self.remove(item: item)
//                case .notYetProcessed:
//                    break
//                }
//            }.catch { error in
//
//            }
        }
    }
    
    func add(item: PinItem) {
        pendingTxList.insert(item)
        postNotification(item: item, isNew: true)
        start()
    }
    
    func remove(item: PinItem) {
        pendingTxList.remove(item)
        postNotification(item: item, isNew: false)
    }
    
    func postNotification(item: PinItem, isNew: Bool) {
        if isNew {
            NotificationCenter.default.post(name: .newPendingTransaction, object: nil, userInfo: ["item": item])
        } else {
            NotificationCenter.default.post(name: .removePendingTransaction, object: nil, userInfo: ["item": item])
        }
    }
    
}
