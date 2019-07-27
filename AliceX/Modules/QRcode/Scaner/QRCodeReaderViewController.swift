//
//  QRCodeReaderViewController.swift
//  AliceX
//
//  Created by lmcmz on 28/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit

class QRCodeReaderViewController: LBXScanViewController {

    @IBOutlet weak var lightButton: UIImageView!
    @IBOutlet weak var containView: UIView!
    @IBOutlet weak var navView: UIView!
    
    var block: StringBlock!
    
    class func make(block: @escaping StringBlock) -> LBXScanViewController   {
        let vc = QRCodeReaderViewController()
        vc.block = block
        return vc
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scanResultDelegate = self
        
        var style = LBXScanViewStyle()
        style.animationImage = UIImage(named: "qrcode_scan_blue")
        scanStyle = style
        setNeedCodeImage(needCodeImg: true)
        scanStyle?.centerUpOffset += 10
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
    
    @IBAction func myqrcodeClicked() {
        let vc = MyQRCodeViewController()
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func backButtonClicked() {
        guard self.navigationController != nil else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        self.navigationController?.popViewController(animated: true)
    }
}

extension QRCodeReaderViewController: LBXScanViewControllerDelegate {
    func scanFinished(scanResult: LBXScanResult, error: String?) {
        
        if error != nil {
            scanObj?.start()
            return
        }
        
        block(scanResult.strScanned ?? "")
        self.backButtonClicked()
    }
    
}
