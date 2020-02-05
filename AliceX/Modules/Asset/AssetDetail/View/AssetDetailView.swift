//
//  AssetDetailView.swift
//  AliceX
//
//  Created by lmcmz on 4/2/20.
//  Copyright © 2020 lmcmz. All rights reserved.
//

import Kingfisher
import UIKit

class AssetDetailView: BaseView {
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var amountLabel: UILabel!

    var coin: Coin = .coin(chain: .Ethereum)

    override class func instanceFromNib() -> AssetDetailView {
        let view = UINib(nibName: nameOfClass, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! AssetDetailView
        view.isHeroEnabled = true
        return view
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        logoImageView.layer.cornerRadius = logoImageView.frame.height / 2
    }

    override func configure() {
        logoImageView.kf.setImage(with: coin.image, placeholder: Constant.placeholder)
        amountLabel.text = coin.info?.symbol

        logoImageView.heroID = coin.id
    }
}
