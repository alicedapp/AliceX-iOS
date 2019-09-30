//
//  WCQRCodeViewController.swift
//  AliceX
//
//  Created by lmcmz on 26/9/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit

// TODO: Dismiss with swipe
class WCQRCodeViewController: BaseViewController {

    @IBOutlet var container: UIView!
    @IBOutlet var shareConver: UIView!
    @IBOutlet var qrcodeView: UIImageView!
    
    var url: String = "https://www.alicedapp.com"
    
    class func make(url: String) -> WCQRCodeViewController {
        let vc = WCQRCodeViewController()
        vc.url = url
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let qrcode = LBXScanWrapper.createCode(codeType: "CIQRCodeGenerator",
                                               codeString: url,
                                               size: qrcodeView.bounds.size,
                                               qrColor: UIColor.black,
                                               bkColor: UIColor.white)
        
        qrcodeView.image = qrcode
    }
    
    @IBAction func backBtnWithHUDManager() {
        HUDManager.shared.dismiss()
    }
    
    @IBAction func shareButtonClick() {
        shareConver.isHidden = false
        let image = container.snapshot()
        HUDManager.shared.dismiss()
        SwiftHelper.share(text: "", image: image, urlString: url)
        shareConver.isHidden = true
    }

}
