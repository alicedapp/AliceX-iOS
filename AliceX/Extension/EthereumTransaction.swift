//
//  EthereumTransaction.swift
//  AliceX
//
//  Created by lmcmz on 10/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import web3swift
import HandyJSON
import BigInt

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
//    var intrinsicChainID: String?
    var from: String?
    var hash: String?
    
    init() {
        return
    }
}

extension EthereumTransaction {
    func toJsonString() -> String {
        var model = EthereumTransactionModel()
        
        model.nonce = String(self.nonce)
        model.gasPrice = String(self.gasPrice)
        model.gasLimit = String(describing: self.gasLimit)
        model.to = self.to.address
        model.value = String(self.value)
        model.data = self.data.toHexString().addHexPrefix().lowercased()
        model.v = String(self.v)
        model.r = String(self.r)
        model.s = String(self.s)
        model.chainID = String(describing: self.intrinsicChainID)
        model.inferedChainID = String(describing: self.inferedChainID)
        model.from = String(describing: self.sender?.address)
        model.hash = String(describing: self.hash?.toHexString().addHexPrefix())
        return model.toJSONString(prettyPrint: true)!
    }
}
