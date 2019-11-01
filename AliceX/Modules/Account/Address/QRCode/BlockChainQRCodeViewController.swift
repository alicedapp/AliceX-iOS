//
//  BlockChainQRCodeViewController.swift
//  AliceX
//
//  Created by lmcmz on 30/10/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit
import Kingfisher

class BlockChainQRCodeViewController: BaseViewController {

    @IBOutlet var qrcodeView: UIImageView!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var container: UIView!
    @IBOutlet var logoContainer: UIView!
    @IBOutlet var logoImageView: UIImageView!
    
    var chain: BlockChain = .Ethereum
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var address = WalletCore.shared.address(blockchain: chain)

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
        logoImageView.kf.setImage(with: URL(string: chain.image)!, placeholder: Constant.placeholder)
    }
}
