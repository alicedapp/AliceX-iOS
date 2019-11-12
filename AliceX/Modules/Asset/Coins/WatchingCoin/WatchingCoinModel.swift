//
//  WatchingCoinModel.swift
//  AliceX
//
//  Created by lmcmz on 6/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import HandyJSON

struct WatchingCoinModel {
    var address: String
    var info: [WatchingCoinInfo]
}

struct WatchingCoinInfo {
    var id: String
    var info: CoinInfo
}
