//
//  BlockChainQRCodeView.swift
//  AliceX
//
//  Created by lmcmz on 30/10/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit
//import JXSegmentedView

class BlockChainQRCodeView: BaseView {

    @IBOutlet var qrcodeView: UIImageView!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var logoContainer: UIView!
    @IBOutlet var logoImageView: UIImageView!
    
    var chain: BlockChain = .Ethereum
    
    override class func instanceFromNib() -> BlockChainQRCodeView {
        let view = UINib(nibName: nameOfClass, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! BlockChainQRCodeView
        return view
    }
    
    override class func awakeFromNib() {
//        frame = CGRect(x: 0, y: 0, width: Constant.SCREEN_WIDTH - 20, height: 440)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        frame = CGRect(x: 0, y: 0, width: Constant.SCREEN_WIDTH - 20, height: 440)
//        layoutIfNeeded()
        logoContainer.layer.cornerRadius = logoContainer.frame.height / 2
//        logoImageView.layer.cornerRadius = logoImageView.frame.height / 2
//        logoImageView.kf.setImage(with: URL(string: chain.image)!, placeholder: Constant.placeholder)
    }
    
    override func configure() {
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

//extension BlockChainQRCodeView: JXSegmentedListContainerViewListDelegate {
//    func listView() -> UIView {
//        layoutIfNeeded()
//        return self
//    }
//
//    func listWillAppear() {
//        frame = CGRect(x: 0, y: 0, width: Constant.SCREEN_WIDTH - 20, height: 440)
//    }
//}
