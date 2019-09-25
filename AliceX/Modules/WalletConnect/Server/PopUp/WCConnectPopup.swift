//
//  WCConnectPopup.swift
//  AliceX
//
//  Created by lmcmz on 24/9/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit
import Kingfisher

class WCConnectPopup: UIView {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var arrowImage: UIImageView!
    
    @IBOutlet var portA: UIImageView!
    @IBOutlet var portALabel: UILabel!
    
    @IBOutlet var portB: UIImageView!
    @IBOutlet var portBLabel: UILabel!
    
    var comfirmBlock: VoidBlock?
    var cancelBlock: VoidBlock?
    
    class func make(portAImage: URL?, portAName: String, portBImage: URL?, portBName: String, comfirmBlock: VoidBlock?, cancelBlock: VoidBlock?) -> WCConnectPopup {
        let view = UINib(nibName: nameOfClass, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! WCConnectPopup
        view.configure(portAImage: portAImage, portAName: portAName, portBImage: portBImage, portBName: portBName)
        view.comfirmBlock = comfirmBlock
        view.cancelBlock = cancelBlock
        return view
    }
    
    override func awakeFromNib() {
        arrowImage.transform = CGAffineTransform(scaleX: -1, y: 1)
        roundCorners(corners: [.topLeft, .topRight], radius: 20)
    }
    
    func configure(portAImage: URL?, portAName: String, portBImage: URL?, portBName: String) {
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
        HUDManager.shared.dismiss()
    }
    
    @IBAction func cancelButtonClick() {
        guard let block = cancelBlock else {
            return
        }
        block!()
        HUDManager.shared.dismiss()
    }
}
