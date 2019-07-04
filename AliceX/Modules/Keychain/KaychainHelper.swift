//
//  KaychainHelper.swift
//  AliceX
//
//  Created by lmcmz on 10/6/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import KeychainSwift

class KeychainHepler {
    static let shared = KeychainHepler()
    
    var keychain: KeychainSwift?
    
    private init() {
        keychain = KeychainSwift(keyPrefix: Setting.AliceKeychainPrefix)
        keychain!.synchronizable = true
    }
    
    class func saveToKeychain(value: String, key: String) {
        KeychainHepler.shared.keychain!.set(value, forKey: key)
    }
    
    class func fetchKeychain(key: String) -> String? {
        return KeychainHepler.shared.keychain!.get(key)
    }
}
