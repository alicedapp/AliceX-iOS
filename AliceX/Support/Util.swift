//
//  Util.swift
//  AliceX
//
//  Created by lmcmz on 12/9/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation

class Util {
    
    static let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    static let build = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
    
    //TODO
    class func isUpdated() -> Bool {
        return false
    }
}
