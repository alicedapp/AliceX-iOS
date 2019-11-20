//
//  FaviconGrabberModel.swift
//  AliceX
//
//  Created by lmcmz on 20/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import HandyJSON

struct FaviconGrabberModel: HandyJSON {
    var src: String!
    var type: String?
    var sizes: String?
}
