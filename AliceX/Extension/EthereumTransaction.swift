//
//  EthereumTransaction.swift
//  AliceX
//
//  Created by lmcmz on 10/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import BigInt
import HandyJSON
import web3swift

struct EthereumTransactionModel: HandyJSON {
    var nonce: String?
    var gasPrice: String?
    var gasLimit: String?
    var to: String?
    var value: String?
    var data: String?
    var v: String?
    var r: String?
    var s: String?
    var chainID: String?
    var inferedChainID: String?
    var from: String?
    var hash: String?

    init() {
        return
    }
}

extension EthereumTransaction {
    func toJsonString() -> String {
        var model = EthereumTransactionModel()
        model.nonce = String(nonce)
        model.gasPrice = String(gasPrice)
        model.gasLimit = String(describing: gasLimit)
        model.to = to.address
        if let v = value {
            model.value = String(v)
        }
        model.data = data.toHexString().addHexPrefix().lowercased()
        model.v = String(v)
        model.r = String(r)
        model.s = String(s)
        model.chainID = String(describing: intrinsicChainID)
        model.inferedChainID = String(describing: inferedChainID)
        model.from = String(describing: sender!.address)
        model.hash = String(describing: hash!.toHexString().addHexPrefix())
        return model.toJSONString(prettyPrint: true)!
    }
}
