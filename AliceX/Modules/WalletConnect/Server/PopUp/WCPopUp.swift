//
//  WCPopUp.swift
//  AliceX
//
//  Created by lmcmz on 24/9/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit

class WCPopUp: UIView {
    
    @IBOutlet var titleLabel: UILabel!
    
    var comfirmBlock: VoidBlock?
    var cancelBlock: VoidBlock?
    
    class func make(portAImage: URL?, portAName: String, portBImage: URL?, portBName: String, comfirmBlock: VoidBlock?, cancelBlock: VoidBlock?) -> WCConnectPopup {
        let view = UINib(nibName: nameOfClass, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! WCConnectPopup
        view.configure(portAImage: portAImage, portAName: portAName, portBImage: portBImage, portBName: portBName)
        view.comfirmBlock = comfirmBlock
        view.cancelBlock = cancelBlock
        return view
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
