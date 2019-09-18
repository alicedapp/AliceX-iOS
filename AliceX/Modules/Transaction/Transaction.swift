//
//  Transaction.swift
//  AliceX
//
//  Created by lmcmz on 16/9/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation

struct EthTransaction: Hashable {
    var hash: String
    
    init?(hash: String) {
        if !hash.hasPrefix("0x") {
            return nil
        }
        
        if hash.count != 66 {
            return nil
        }
        
        self.hash = hash
    }
}
