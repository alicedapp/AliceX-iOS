//
//  DAppModel.swift
//  AliceX
//
//  Created by lmcmz on 14/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import HandyJSON

class DAppModel: HandyJSON {
    var name: String!
    var description: String?
    var link: String!
    var img: String?
    var category: String?
    
    required init() {
    }
}
