//
//  RNModule.swift
//  AliceX
//
//  Created by lmcmz on 1/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import UIKit

enum AliceRN: String {
    case alice
    case embeddedView
}

class RNModule {
    class func makeViewController(module: AliceRN) -> UIViewController {
        let vc = BaseRNViewController()
        let rnView = RCTRootView(bridge: AppDelegate.rnBridge(), moduleName: module.rawValue, initialProperties: nil)
        vc.view = rnView
        return vc
    }

    class func makeView(module: AliceRN) -> RCTRootView? {
        let rnView = RCTRootView(bridge: AppDelegate.rnBridge(), moduleName: module.rawValue.firstUppercased, initialProperties: nil)
        return rnView
    }
}
