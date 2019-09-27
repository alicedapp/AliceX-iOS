//
//  PinManager+WalletConnect.swift
//  AliceX
//
//  Created by lmcmz on 26/9/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation

extension PinManager {
    
    @objc func walletConnectDisconnect(noti: Notification) {
        guard let userInfo = noti.userInfo, let key = userInfo["key"] as? String else {
            return
        }
        
        for item in pinList {
            if item.isWalletConnect && item.wcKey == key{
                guard let index = pinList.firstIndex(of: item) else {
                    return
                }
                pinList.remove(at: index)
            }
        }
        
    }
}
