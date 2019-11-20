//
//  CameraContainerViewController.swift
//  AliceX
//
//  Created by lmcmz on 19/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit

class CameraContainerViewController: LBXScanViewController {
    @IBOutlet var blurView: UIVisualEffectView!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

//    override func viewWillAppear(_ animated: Bool) {

//        if qRScanView == nil {
//            return
//        }
//
//        qRScanView?.startScanAnimation()
//        scanObj?.start()
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        var style = LBXScanViewStyle()
        style.animationImage = UIImage(named: "qrcode_scan_light_white")
        style.colorAngle = UIColor.lightGray
        scanStyle = style
        setNeedCodeImage(needCodeImg: false)
        scanStyle?.centerUpOffset += 10
        isOpenInterestRect = true
    }

    func activeCamera() {
        if qRScanView == nil {
            qRScanView = LBXScanView(frame: view.frame, vstyle: scanStyle!)
            view.addSubview(qRScanView!)
            delegate?.drawwed()
            qRScanView?.deviceStartReadying(readyStr: readyString)
        }

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            perform(#selector(LBXScanViewController.startScan), with: nil, afterDelay: 0.3)
        }
    }

    func disableCamera() {
//        qRScanView?.removeFromSuperview()
        qRScanView?.stopScanAnimation()
        scanObj?.stop()
    }
}
