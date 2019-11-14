//
//  WalletManager+ENS.swift
//  AliceX
//
//  Created by lmcmz on 14/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import web3swift

extension WalletManager {
    
    func test() {
        let web = web3(provider: InfuraProvider(Networks.Mainnet)!)
        let ens = ENS(web3: web)!
        do {
            let address = try ens.getAddress(forNode: "markpereira.eth")
            print("AAAA \(address.address)")
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
