//
//  NativeVCModule.swift
//  AliceX
//
//  Created by lmcmz on 4/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import SPStorkController

@objc(NativeVCModule)
class NativeVCModule: NSObject {
    @objc func setting() {
        let topVC = UIApplication.topViewController()
        let modal = SettingViewController()
        let navi = UINavigationController(rootViewController: modal)
        let transitionDelegate = SPStorkTransitioningDelegate()
        navi.transitioningDelegate = transitionDelegate
        navi.modalPresentationStyle = .custom
        transitionDelegate.showIndicator = false
        transitionDelegate.indicatorColor = UIColor.white
        transitionDelegate.hideIndicatorWhenScroll = true
        topVC?.present(navi, animated: true, completion: nil)
    }
}
