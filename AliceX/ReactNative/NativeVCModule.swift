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

        DispatchQueue.main.async {
            let topVC = UIApplication.topViewController()
            let modal = SettingViewController()
            let navi = BaseNavigationController(rootViewController: modal)
            let transitionDelegate = SPStorkTransitioningDelegate()
            navi.transitioningDelegate = transitionDelegate
            navi.modalPresentationStyle = .custom
            transitionDelegate.showIndicator = false
            transitionDelegate.indicatorColor = UIColor.white
            transitionDelegate.hideIndicatorWhenScroll = true
            topVC?.present(navi, animated: true, completion: nil)
        }
    }

    @objc func browser(_ url: String) {
        DispatchQueue.main.async {
            
            if #available(iOS 13.0, *) {
                let topVC = UIApplication.topViewController()
                let vc = BrowserViewController()
                vc.urlString = url
                topVC!.hero.isEnabled = true
                vc.hero.isEnabled = true
                vc.hero.modalAnimationType = .selectBy(presenting:.cover(direction: .up), dismissing:.uncover(direction: .down))
                topVC?.navigationController?.pushViewController(vc, animated: true)
                return
            }
            let topVC = UIApplication.topViewController()
            let vc = BrowserViewController()
            vc.urlString = url
            vc.hero.modalAnimationType = .selectBy(presenting:.cover(direction: .up), dismissing:.uncover(direction: .down))
//            topVC?.present(vc, animated: true, completion: nil)
            topVC?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
