//
//  SettingViewController+DarkMode.swift
//  AliceX
//
//  Created by lmcmz on 23/10/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation

extension SettingViewController: CAAnimationDelegate {
    func changeThemeAnimation() {
        guard let window = UIApplication.shared.keyWindow, let frame = darkSwitch?.superview!.convert(darkSwitch.frame, from: window)
        else {
            return
        }

        darkSwitch.isUserInteractionEnabled = false

        let snapshot = window.snapshot()
        let snapshotView = UIImageView(frame: window.bounds)
        snapshotView.image = snapshot
        snapshotView.tag = 10
        window.addSubview(snapshotView)

        //        window.bringSubviewToFront(darkSwitch)

        let switchFrame = CGRect(x: frame.origin.x, y: -frame.origin.y + 30,
                                 width: frame.width,
                                 height: frame.height)

        let maskStartBP = UIBezierPath(roundedRect: switchFrame, cornerRadius: 10)
        let maskFinalBP = UIBezierPath(roundedRect: UIScreen.main.bounds, cornerRadius: 1)

        let maskLayer = CAShapeLayer()

        //        let path = CGMutablePath()
        //        path.addPath(maskFinalBP.cgPath)
        //        path.addPath(maskStartBP.cgPath)
        //
        //        maskLayer.path = path
        //        maskLayer.fillRule = .evenOdd
        maskLayer.path = maskStartBP.cgPath
        snapshotView.layer.mask = maskLayer

        let maskLayerAnimation = CABasicAnimation(keyPath: "path")
        maskLayerAnimation.fromValue = maskFinalBP.cgPath
        maskLayerAnimation.toValue = maskStartBP.cgPath
        maskLayerAnimation.duration = 0.8000
        maskLayerAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        maskLayerAnimation.delegate = self
        maskLayer.add(maskLayerAnimation, forKey: "path")

        //        UIView.animate(withDuration: 0.79999, delay: 0.7998, options: [], animations: {
        //            snapshotView.alpha = 0
        //        }) { (_) in
        //            snapshotView.isHidden = true
        //            snapshotView.removeFromSuperview()
        //        }
    }

    func animationDidStart(_: CAAnimation) {
        if #available(iOS 13.0, *) {
            if darkSwitch.isOn {
                UIApplication.shared.keyWindow?.overrideUserInterfaceStyle = .dark
            } else {
                UIApplication.shared.keyWindow?.overrideUserInterfaceStyle = .light
            }
        }
    }

    func animationDidStop(_: CAAnimation, finished _: Bool) {
        darkSwitch.isUserInteractionEnabled = true
        if let snapshot = UIApplication.shared.keyWindow!.viewWithTag(10) {
            snapshot.removeFromSuperview()
        }
        //        if let snapshot = view.viewWithTag(11) {
        //            snapshot.removeFromSuperview()
        //        }
    }
}
