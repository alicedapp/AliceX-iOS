//
//  RNModule.swift
//  AliceX
//
//  Created by lmcmz on 1/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import UIKit

enum AliceRN {
    case alice
    case embeddedView
    case app(name: String)

    var moduleName: String {
        switch self {
        case .alice, .app:
            return "alice"
        case .embeddedView:
            return "EmbeddedView"
        }
    }

    var props: [String: String]? {
        switch self {
        case let .app(name):
            return ["navigationRoute": name]
        case .alice, .embeddedView:
            return nil
        }
    }
}

class RNModule {
    class func makeViewController(module: AliceRN) -> UIViewController {
        let vc = BaseRNViewController()
        let rnView = RCTRootView(bridge: AppDelegate.rnBridge(), moduleName: module.moduleName, initialProperties: module.props)
        vc.view = rnView
        return vc
    }

    class func makeVCwithApp(item: HomeItem) -> UIViewController {
        let vc = BaseRNAppViewController.make(item: item)
        let module = AliceRN.app(name: item.name)
        let rnView = RCTRootView(bridge: AppDelegate.rnBridge(), moduleName: module.moduleName, initialProperties: module.props)
        vc.view = rnView
        return vc
    }

    class func makeView(module: AliceRN) -> RCTRootView? {
        let rnView = RCTRootView(bridge: AppDelegate.rnBridge(), moduleName: module.moduleName, initialProperties: nil)
        return rnView
    }
}
