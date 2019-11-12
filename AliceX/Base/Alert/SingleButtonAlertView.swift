//
//  ErrorAlertView.swift
//  AliceX
//
//  Created by lmcmz on 25/9/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation

class SingleButtonAlertView: UIView {
    @IBOutlet var titleView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!

    class func make(content: String, isAlert: Bool = false) -> SingleButtonAlertView {
        let view = UINib(nibName: nameOfClass, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SingleButtonAlertView
        view.titleLabel.text = isAlert ? "Alert" : "Error"
        view.contentLabel.text = content
        view.titleView.backgroundColor = isAlert ? AliceColor.dark : AliceColor.red
        return view
    }

    @IBAction func click() {
        HUDManager.shared.dismiss()
    }
}
