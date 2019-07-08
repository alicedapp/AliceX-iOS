//
//  KaychainHelper.swift
//  AliceX
//
//  Created by lmcmz on 10/6/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import KeychainAccess

class KeychainHepler {
    static let shared = KeychainHepler()
    
    var keychain: Keychain?
    
    private init() {
        keychain = Keychain(service: Setting.AliceKeychainPrefix)
    }
    
    func saveToKeychain(value: String, key: String) {
        keychain![key] = value
    }
    
    func fetchKeychain(key: String) -> String? {
        return keychain![key]
    }
}
