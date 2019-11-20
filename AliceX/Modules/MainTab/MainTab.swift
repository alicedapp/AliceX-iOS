//
//  MainTab.swift
//  AliceX
//
//  Created by lmcmz on 26/10/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation

enum MainTab: Int, CaseIterable {
    case mini
    case asset

    var vc: UIViewController {
        switch self {
        case .mini:
            return
                MiniAppViewController()
//                RNModule.makeViewController(module: .alice)
//                SettingViewController()

        case .asset:
            return AssetViewController()
//        case .profile:
//            return UIViewController()
//            return ProfileViewController()
        }
    }

    var icon: UIImage {
        switch self {
        case .mini:
            return UIImage(named: "back")!
        case .asset:
            return UIImage(named: "back")!
//        case .transaction:
//            return UIImage(named: "back")!
//        case .profile:
//            return UIImage(named: "back")!
        }
    }
}
