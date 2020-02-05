//
//  BaseView.swift
//  AliceX
//
//  Created by lmcmz on 14/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit

class BaseView: UIView {
    class func instanceFromNib() -> BaseView {
        let view = UINib(nibName: nameOfClass, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! BaseView
        view.configure()
        view.isHeroEnabledForSubviews = true
        view.isHeroEnabled = true
        return view
    }

    func configure() {}
}
