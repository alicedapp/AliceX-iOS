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
                let vc = BrowserWrapperViewController()
                vc.urlString = url
                topVC!.hero.isEnabled = true
                vc.hero.isEnabled = true
                vc.hero.modalAnimationType = .selectBy(presenting: .cover(direction: .up), dismissing: .uncover(direction: .down))
                topVC?.navigationController?.pushViewController(vc, animated: true)
                return
            }
            let topVC = UIApplication.topViewController()
            let vc = BrowserWrapperViewController()
            vc.urlString = url
            vc.hero.modalAnimationType = .selectBy(presenting: .cover(direction: .up), dismissing: .uncover(direction: .down))
//            topVC?.present(vc, animated: true, completion: nil)
            topVC?.navigationController?.pushViewController(vc, animated: true)
        }
    }

    @objc func qrScanner(_ resolve: @escaping RCTPromiseResolveBlock,
                         reject _: @escaping RCTPromiseRejectBlock) {
        DispatchQueue.main.async {
            let topVC = UIApplication.topViewController()
            let vc = QRCodeReaderViewController.make { result in
                resolve(result)
            }
            guard let _ = topVC?.navigationController else {
                topVC?.present(vc, animated: true, completion: nil)
                return
            }
            topVC?.navigationController?.pushViewController(vc, animated: true)
        }
    }

    @objc func getOrientation(_ resolve: @escaping RCTPromiseResolveBlock,
                              reject _: @escaping RCTPromiseRejectBlock) {
        DispatchQueue.main.async {
            let result = CallRNModule.getOrientation()
            resolve(result)
        }
    }

    @objc func isDarkMode(_ resolve: @escaping RCTPromiseResolveBlock,
                          reject _: @escaping RCTPromiseRejectBlock) {
        DispatchQueue.main.async {
            if #available(iOS 12.0, *) {
                if UIApplication.shared.keyWindow!.traitCollection.userInterfaceStyle == .dark {
                    resolve(true)
                } else {
                    resolve(false)
                }
            } else {
                resolve(false)
            }
        }
    }
}
