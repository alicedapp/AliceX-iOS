//
//  AssetDetailHeader.swift
//  AliceX
//
//  Created by lmcmz on 5/2/20.
//  Copyright © 2020 lmcmz. All rights reserved.
//

import UIKit

class AssetDetailHeader: BaseView {
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var amountLabel: UILabel!

    override class func instanceFromNib() -> AssetDetailHeader {
        let view = UINib(nibName: nameOfClass, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! AssetDetailHeader
//        view.configure()
        view.isHeroEnabledForSubviews = true
        view.isHeroEnabled = true
        return view
    }

    func scrollViewDidScroll(contentOffsetY: CGFloat) {
        var frame = self.frame
        frame.size.height -= contentOffsetY
        frame.origin.y = contentOffsetY
        self.frame = frame
    }

    func configure(coin _: Coin) {}
}
