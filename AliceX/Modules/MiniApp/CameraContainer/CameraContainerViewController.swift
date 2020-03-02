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

    @IBOutlet var coverView: UIView!

    var block: StringBlock!
    var noFirst: Bool = false

    var isActive: Bool = false

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

        scanResultDelegate = self

        var style = LBXScanViewStyle()
//        style.animationImage = UIImage(named: "qrcode_scan_light_white")
        style.colorAngle = UIColor.lightGray
        scanStyle = style
        setNeedCodeImage(needCodeImg: false)
        scanStyle?.centerUpOffset += 10
//        isOpenInterestRect = true
    }

    override func viewDidLayoutSubviews() {
        view.bringSubviewToFront(coverView)
    }

    open override func viewDidAppear(_: Bool) {
        view.layoutIfNeeded()
        drawScanView()

        if noFirst, isActive {
            startScan()
        }
    }

    func activeCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            perform(#selector(LBXScanViewController.startScan), with: nil, afterDelay: 0.3)
        }
        noFirst = true
        isActive = true
    }

    func disableCamera() {
//        qRScanView?.removeFromSuperview()
        qRScanView?.stopScanAnimation()
        scanObj?.stop()
        isActive = false
    }
}

extension CameraContainerViewController: LBXScanViewControllerDelegate {
    func scanFinished(scanResult: LBXScanResult, error: String?) {
        if error != nil {
            scanObj?.start()
            return
        }

        guard let strScanned = scanResult.strScanned else {
            scanObj?.start()
            return
        }

        if strScanned.hasPrefix("wc:") {
            WCServerHelper.shared.connect(url: scanResult.strScanned!)
            block("")
            return
        }

        block(strScanned.dropEthPrefix())
    }
}
