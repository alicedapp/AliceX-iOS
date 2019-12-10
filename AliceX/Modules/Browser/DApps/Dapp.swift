//
//  Dapp.swift
//  AliceX
//
//  Created by lmcmz on 12/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation

enum ETHDAppMethod: String, CaseIterable {
    case signTransaction
    case signTypedMessage
    case signPersonalMessage
    case signMessage
    case requestAccounts
}
