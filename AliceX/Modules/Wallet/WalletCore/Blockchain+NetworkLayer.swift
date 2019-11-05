//
//  Blockchain+NetworkLayer.swift
//  AliceX
//
//  Created by lmcmz on 5/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import PromiseKit

extension BlockChain: NetworkLayer {
    func getBalance() -> Promise<Double> {
        return Promise<Double> { seal in
            switch self {
            case .Ethereum:
                firstly {
                    TransactionManager.shared.etherBalance()
                }.done { balanceStr in
                    seal.fulfill(Double(balanceStr)!)
                }.catch { (error) in
                    seal.reject(error)
                }
            case .Bitcoin:
                firstly { () -> Promise<AmberdataBalance> in
                    API(AmberData.accountBalance(address: WalletCore.shared.address(blockchain: self), blockchain: self), path: "payload")
                }.done { model in
                    seal.fulfill(Double(model.value)!)
                }.catch { (error) in
                    seal.reject(error)
                }
            default:
                seal.fulfill(0)
            }
        }
    }
}
