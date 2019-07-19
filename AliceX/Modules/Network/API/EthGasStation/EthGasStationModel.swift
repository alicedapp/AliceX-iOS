//
//  EthGasStationModel.swift
//  AliceX
//
//  Created by lmcmz on 19/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import HandyJSON

struct EthGasStationModel: HandyJSON {
    var fast: Float?
    var fastest: Float?
    var safeLow: Float?
    var average: Float?
    var block_time: Float?
    var blockNum: Int64?
    var speed: Float?
    var safeLowWait: Float?
    var avgWait: Float?
    var fastWait: Float?
    var fastestWait: Float?
}
