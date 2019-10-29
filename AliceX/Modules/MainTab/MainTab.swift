//
//  MainTab.swift
//  AliceX
//
//  Created by lmcmz on 26/10/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation

enum MainTab: Int, CaseIterable {
    case asset
    case mini

//    case transaction
//    case profile

    var vc: UIViewController {
        switch self {
        case .mini:
//            return UIViewController()
            return RNModule.makeViewController(module: .alice)
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
