//
//  TransactionRecordsHelper.swift
//  AliceX
//
//  Created by lmcmz on 10/2/20.
//  Copyright © 2020 lmcmz. All rights reserved.
//

import Foundation
import Haneke
import PromiseKit

class TransactionRecordHelper {
    static let shared = TransactionRecordHelper()
    var list = Set<AmberdataTXModel>()

    init() {
        //        loadFromCache().done { list in
        //            let setList = Set(list.compactMap{ $0 })
        //            TransactionRecordHelper.shared.list = setList
        //        }
        NotificationCenter.default.addObserver(self, selector: #selector(accountChange), name: .accountChange, object: nil)
    }

    @objc func accountChange() {
        TransactionRecordHelper.shared.loadFromCache()
    }

    func fetchTXHistory(page: Int = 0, size: Int = 30,
                        address: String = WalletManager.currentAccount!.address,
                        blockchain: BlockChain = .Ethereum) -> Promise<[AmberdataTXModel]> {
        return Promise<[AmberdataTXModel]> { seal in

            var requestAddress = address
            if blockchain == .Bitcoin {
                requestAddress = WalletCore.address(blockchain: .Bitcoin)
            }

            firstly { () -> Promise<[AmberdataTXModel?]> in
                API(AmberData.addressTX(address: requestAddress, page: page, size: size, blokchain: blockchain), path: "payload.records")
            }.done { list in
                let array = list.compactMap { $0 }
                let setList = Set(array)
                TransactionRecordHelper.shared.list = TransactionRecordHelper.shared.list.union(setList)
                self.storeInCache()
                seal.fulfill(array)
            }.catch { error in
                seal.reject(error)
                //                print(error.localizedDescription)
            }
        }
    }
}

extension TransactionRecordHelper {
    func loadFromCache(blockchain: BlockChain = .Ethereum) -> Promise<[AmberdataTXModel]> {
        return Promise<[AmberdataTXModel]> { seal in

            guard let account = WalletManager.currentAccount else {
                return
            }

            let key = "\(CacheKey.txHistory).\(blockchain.symbol).\(account.address)"
            Shared.stringCache.fetch(key: key).onSuccess { string in

                if let list = [AmberdataTXModel].deserialize(from: string) {
                    let setList = Set(list.compactMap { $0 })
                    TransactionRecordHelper.shared.list = setList

                    seal.fulfill(list.compactMap { $0 })
                }
                seal.reject(MyError.FoundNil("Fetch Tx history failed"))

            }.onFailure { error in
                seal.reject(error ?? MyError.FoundNil("Fetch Tx history failed"))
            }
        }
    }

    func storeInCache(blockchain: BlockChain = .Ethereum) {
        let key = "\(CacheKey.txHistory).\(blockchain.symbol).\(WalletManager.currentAccount!.address)"

        if let string = Array(TransactionRecordHelper.shared.list).toJSONString() {
            Shared.stringCache.set(value: string, key: key)
        }
    }
}
