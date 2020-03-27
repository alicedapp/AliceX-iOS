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
            .label("Alice Mnemonic")
            .synchronizable(true)
    }

    func saveToKeychain(value: String, key: String) {
        do {
            try keychain?.synchronizable(true).set(value, key: key)
        } catch {
            HUDManager.shared.showError(text: "Save mnemonic to keychain failed")
        }
    }

    func fetchKeychain(key: String) -> String? {
        do {
            let value = try keychain?.get(key)
            return value
        } catch {
            HUDManager.shared.showError(text: "Fetch mnemonic from keychain failed")
        }
        return nil
    }
}
