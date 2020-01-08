//
//  WalletStruct.swift
//  AliceX
//
//  Created by lmcmz on 10/6/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import HandyJSON

struct Account: Codable, Equatable {
    let address: String
//    let data: Data
//    let isHD: Bool
    
    var name: String
    var imageName: String
//    var color: UIColor
}

struct HDKey {
    let name: String?
    let address: String
}

//struct Account {
//    let wallet: Wallet
//    let image: UIImage
//}

// struct ERC20Token {
//    var name: String
//    var address: String
//    var decimals: String
//    var symbol: String
// }
