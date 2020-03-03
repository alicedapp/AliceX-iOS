//
//  TransactionManager+Pending.swift
//  AliceX
//
//  Created by lmcmz on 11/9/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import PromiseKit
import web3swift

private var fetchPendingFrequency: TimeInterval = 5.0

class PendingTransactionHelper {
    static let shared = PendingTransactionHelper()

    var pendingTxList: Set<PinItem> = Set<PinItem>()
    var timer: Timer!

    var errorCount: Int = 0

    func start() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }

        errorCount = 0

        timer = Timer(timeInterval: fetchPendingFrequency, target: self, selector: #selector(fetchStatus), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .default)
        timer.fire()
    }

    func stop() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
        errorCount = 0
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
                fetchSingleTX(txHash: item.txHash, network: item.network)
            }.done { receipt in
                switch receipt.status {
                case .ok:
                    if !self.pendingTxList.contains(item) {
                        return
                    }
                    HUDManager.shared.showSuccess(text: "Transaction Confirmed")
                    self.remove(item: item, isSuccess: true)
                case .failed:
                    HUDManager.shared.showError(text: "Transaction Failed")
                    self.remove(item: item, isSuccess: false)
                case .notYetProcessed:
                    self.errorCount -= 1
                }
            }.catch { error in
                self.errorCount += 1
                print("Fetching TX Status got error, count: \(self.errorCount)")
                if self.errorCount > 10 {
                    self.stop()
                    print(error.localizedDescription)
                }
            }
        }
    }

    func fetchSingleTX(txHash: String, rpcURL: String)
        -> Promise<TransactionReceipt> {
        return Promise<TransactionReceipt> { seal in

            // TODO: Recently, listen to tx, got node error in First Time
            firstly {
                WalletManager.make(url: rpcURL)
            }.then { web3 in
                web3.eth.getTransactionReceiptPromise(txHash)
            }.done { receipt in
                seal.fulfill(receipt)
            }.catch { error in
                seal.reject(error)
            }
        }
    }

    func fetchSingleTX(txHash: String, network: Web3NetEnum)
        -> Promise<TransactionReceipt> {
        let web3 = try! WalletManager.make(type: network)

        return Promise<TransactionReceipt> { seal in

            firstly {
                web3.eth.getTransactionReceiptPromise(txHash)
            }.done { receipt in
                seal.fulfill(receipt)
            }.catch { error in
                seal.reject(error)
            }
        }
    }

    func add(item: PinItem, track: Bool = false) {
        pendingTxList.insert(item)
        postNotification(item: item, isNew: true, isSuccess: true)
        if track {
            start()
        }
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
