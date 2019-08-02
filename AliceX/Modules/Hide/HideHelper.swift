//
//  HideHelper.swift
//  AliceX
//
//  Created by lmcmz on 25/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation

class HideHelper {
    static let shared = HideHelper()

    var window: UIWindow!

    func start() {
        if FaceIDHelper.shared.isUsing {
            return
        }

        window = UIWindow(frame: CGRect(x: 0, y: 0, width: Constant.SCREEN_WIDTH, height: Constant.SCREEN_HEIGHT))
        window.windowLevel = UIWindow.Level.statusBar + 1
        let vc = HideMaskViewController()
        window.rootViewController = vc
        window.isHidden = false
    }

    func stop() {
        if window == nil {
            return
        }

        window.alpha = 1
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
            self.window.alpha = 0
        }) { _ in
            self.window.isHidden = true
        }
    }
}
