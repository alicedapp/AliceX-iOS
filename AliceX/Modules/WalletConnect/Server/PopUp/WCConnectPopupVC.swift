//
//  WCConnectPopupVC.swift
//  AliceX
//
//  Created by lmcmz on 3/3/20.
//  Copyright © 2020 lmcmz. All rights reserved.
//

import UIKit

class WCConnectPopupVC: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var arrowImage: UIImageView!

    @IBOutlet var portA: UIImageView!
    @IBOutlet var portALabel: UILabel!

    @IBOutlet var portB: UIImageView!
    @IBOutlet var portBLabel: UILabel!

    var comfirmBlock: VoidBlock?
    var cancelBlock: VoidBlock?
    
    class func make(portAImage: URL?, portAName: String, portBImage: URL?, portBName: String, comfirmBlock: VoidBlock?, cancelBlock: VoidBlock?) -> WCConnectPopupVC {
        let vc = WCConnectPopupVC()
        vc.configure(portAImage: portAImage, portAName: portAName, portBImage: portBImage, portBName: portBName)
        vc.comfirmBlock = comfirmBlock
        vc.cancelBlock = cancelBlock
        return vc
    }
    
    func configure(portAImage: URL?, portAName: String, portBImage: URL?, portBName: String) {
        view.roundCorners(corners: [.topLeft, .topRight], radius: 20)

        portA.kf.setImage(with: portAImage, placeholder: Constant.placeholder)
        portB.kf.setImage(with: portBImage, placeholder: Constant.placeholder)

        portALabel.text = portAName
        portBLabel.text = portBName
    }
    
    @IBAction func comfirmButtonClick() {
        guard let block = comfirmBlock else {
            return
        }
        block!()
        dismiss(animated: true)
    }

    @IBAction func cancelButtonClick() {
        guard let block = cancelBlock else {
            return
        }
        block!()
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        arrowImage.transform = CGAffineTransform(scaleX: -1, y: 1)
    }

}
