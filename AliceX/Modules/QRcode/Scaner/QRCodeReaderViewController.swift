//
//  QRCodeReaderViewController.swift
//  AliceX
//
//  Created by lmcmz on 28/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit

class QRCodeReaderViewController: LBXScanViewController {
    @IBOutlet var lightButton: UIImageView!
    @IBOutlet var containView: UIView!
    @IBOutlet var navView: UIView!

    var block: StringBlock!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    class func make(block: @escaping StringBlock) -> LBXScanViewController {
        let vc = QRCodeReaderViewController()
        vc.block = block
        return vc
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        scanResultDelegate = self

        var style = LBXScanViewStyle()
        style.animationImage = UIImage(named: "qrcode_scan_light_white")
        style.colorAngle = UIColor.lightGray
        scanStyle = style
        setNeedCodeImage(needCodeImg: false)
        scanStyle?.centerUpOffset += 10
        //        isOpenInterestRect = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        view.bringSubviewToFront(containView)
        view.bringSubviewToFront(navView)
    }

    @IBAction func openOrCloseFlash() {
        scanObj?.changeTorch()
        lightButton.isHighlighted = !lightButton.isHighlighted
    }

    @IBAction func albumBtnClicked() {
        openPhotoAlbum()
    }

    @IBAction func walletConnectBtnClicked() {
        WCClientHelper.shared.create()
    }

    @IBAction func myqrcodeClicked() {
        let vc = MyQRCodeViewController()
        //        vc.modalPresentationStyle = .currentContext
        //        present(vc, animated: true, completion: nil)

        HUDManager.shared.showAlertVCNoBackground(viewController: vc)
    }

    @IBAction func backButtonClicked() {
        guard navigationController != nil else {
            dismiss(animated: true, completion: nil)
            return
        }

        navigationController?.popViewController(animated: true)
    }
}

extension QRCodeReaderViewController: LBXScanViewControllerDelegate {
    func scanFinished(scanResult: LBXScanResult, error: String?) {
        if error != nil {
            block("No result detected")
            scanObj?.start()
            return
        }

        guard let strScanned = scanResult.strScanned else {
            block("No result detected")
            return
        }

        if strScanned.hasPrefix("wc:") {
            WCServerHelper.shared.connect(url: strScanned)
            return
        }

        block(strScanned.dropEthPrefix())
        backButtonClicked()
    }
}
