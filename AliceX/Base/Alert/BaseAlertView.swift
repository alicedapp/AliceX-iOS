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
    @IBOutlet var comfirmLabel: UILabel!
    @IBOutlet var cancelLabel: UILabel!

    var comfirmBlock: VoidBlock?
    var cancelBlock: VoidBlock?

    var title: String?
    var content: String?
    var comfirmText: String?
    var cancelText: String?

    class func instanceFromNib(title: String = "Alert",
                               content: String,
                               comfirmText: String = "Comfirm",
                               cancelText: String = "Cancel",
                               comfirmBlock: VoidBlock?,
                               cancelBlock: VoidBlock?) -> BaseAlertView {
        let view = UINib(nibName: nameOfClass, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! BaseAlertView
        view.title = title
        view.content = content
        view.comfirmText = comfirmText
        view.cancelText = cancelText
        view.comfirmBlock = comfirmBlock
        view.cancelBlock = cancelBlock
        view.configure()
        return view
    }

    override func configure() {
        titleLabel.text = title
        contentLabel.text = content
        comfirmLabel.text = comfirmText
        cancelLabel.text = cancelText
    }

    @IBAction func comfirmBtnClicked() {
        comfirmBlock!!()
//        HUDManager.shared.dismiss()
    }

    @IBAction func cancelBtnClicked() {
        cancelBlock!!()
        HUDManager.shared.dismiss()
    }
}
