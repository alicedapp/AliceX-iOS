//
//  DAppModel.swift
//  AliceX
//
//  Created by lmcmz on 14/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import HandyJSON

enum DAppType: Int, Codable {
    case MiniApp = 0
    case Website = 1
}

class DAppModel: Codable {
    var name: String!
    var description: String?
    var link: String!
    var img: String?
    var category: String?
    var type: DAppType!
    var dappName: String?
}
