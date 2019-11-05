//
//  BaseAlertView.swift
//  AliceX
//
//  Created by lmcmz on 31/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit

class BaseAlertView: BaseView {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var confirmLabel: UILabel!
    @IBOutlet var cancelLabel: UILabel!

    var confirmBlock: VoidBlock!
    var cancelBlock: VoidBlock!

    var title: String?
    var content: String?
    var confirmText: String?
    var cancelText: String?

    class func instanceFromNib(title: String = "Alert",
                               content: String,
                               confirmText: String = "Confirm",
                               cancelText: String = "Cancel",
                               confirmBlock: VoidBlock,
                               cancelBlock: VoidBlock) -> BaseAlertView {
        let view = UINib(nibName: nameOfClass, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! BaseAlertView
        view.title = title
        view.content = content
        view.confirmText = confirmText
        view.cancelText = cancelText
        view.confirmBlock = confirmBlock
        view.cancelBlock = cancelBlock
        view.configure()
        return view
    }

    override func configure() {
        titleLabel.text = title
        contentLabel.text = content
        confirmLabel.text = confirmText
        cancelLabel.text = cancelText
    }

    @IBAction func confirmBtnClicked() {
//        if let block = confirmBlock!() {
//            block!()
//        }
        if confirmBlock != nil {
            confirmBlock!()
        }
        
//        HUDManager.shared.dismiss()
    }

    @IBAction func cancelBtnClicked() {
        
        guard let block = cancelBlock else {
            HUDManager.shared.dismiss()
            return
        }
        
        if block != nil  {
            block!()
        }
        HUDManager.shared.dismiss()
    }
}
