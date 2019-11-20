//
//  WalletManager+ENS.swift
//  AliceX
//
//  Created by lmcmz on 14/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import PromiseKit
import web3swift

extension WalletManager {
    func getENSAddressWithPromise(node: String) -> Promise<EthereumAddress> {
        return Promise<EthereumAddress> { seal in
            guard let ens = ENS(web3: WalletManager.web3Net) else {
                throw WalletError.custom("Init ENS Failed")
            }

            let trimStr = node.trimmingCharacters(in: .whitespacesAndNewlines)
            do {
                try ens.getAddressWithPromise(forNode: trimStr).done { addr in
                    seal.fulfill(addr)
                }.catch { error in
                    seal.reject(error)
                }
            } catch {
                seal.reject(error)
            }
        }
    }
}
