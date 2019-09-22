//
//  MyQRCodeViewController.swift
//  AliceX
//
//  Created by lmcmz on 28/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit

class MyQRCodeViewController: BaseViewController {
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var qrcodeView: UIImageView!
//    @IBOutlet weak var lightButton: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        var address = WalletManager.wallet!.address

        let qrcode = LBXScanWrapper.createCode(codeType: "CIQRCodeGenerator",
                                               codeString: address,
                                               size: qrcodeView.bounds.size,
                                               qrColor: UIColor.black,
                                               bkColor: UIColor.white)
        
        qrcodeView.image = qrcode

        let halfLength = address.count / 2
        let index = address.index(address.startIndex, offsetBy: halfLength)
        address.insert("\n", at: index)
//        let result = address.split(separator: "\n")
        addressLabel.text = address
    }

    @IBAction func copyBtnClicked() {
        UIPasteboard.general.string = WalletManager.wallet?.address
    }

    @IBAction func shareBtnClicked() {}
}
