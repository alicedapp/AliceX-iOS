//
//  CoinListCell.swift
//  AliceX
//
//  Created by lmcmz on 28/10/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Kingfisher
import UIKit
import VBFPopFlatButton

class CoinListCell: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var iconView: UIImageView!
    @IBOutlet var addButton: VBFPopFlatButton!
    @IBOutlet var addBackground: BaseControl!
    @IBOutlet var coinShadow: UIView!

    @IBOutlet var typeLabel: UILabel!

    var coin: Coin!

    override func awakeFromNib() {
        super.awakeFromNib()
        addButton.currentButtonStyle = .buttonRoundedStyle
        addButton.currentButtonType = .buttonAddType
        addButton.tintColor = .white
        addButton.lineRadius = 5
        addButton.lineThickness = 3

        let shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: coinShadow.bounds, cornerRadius: 25).cgPath
        shadowLayer.fillColor = UIColor.white.cgColor
        shadowLayer.shadowColor = UIColor(hex: "#000000", alpha: 0.3).cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0, height: 1.0)
        shadowLayer.shadowOpacity = 0.3
        shadowLayer.shadowRadius = 5

        coinShadow.layer.insertSublayer(shadowLayer, at: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    @IBAction func addButtonClick() {
        let isAdd = addButton.currentButtonType == .buttonAddType
        addButton.currentButtonType = isAdd ? .buttonOkType : .buttonAddType
//        addButton.tintColor = isAdd ? AliceColor.red : .white
        UIView.animate(withDuration: 0.3) {
            self.addBackground.backgroundColor = isAdd ? AliceColor.green : UIColor(hex: "9A9A9A", alpha: 0.5)
        }

        if isAdd {
            WatchingCoinHelper.shared.add(coin: coin, updateCache: true)
        } else {
            WatchingCoinHelper.shared.remove(coin: coin, updateCache: true)
        }
    }

    func configure(coin: Coin) {
        self.coin = coin
//        if {
//        }

        let isAdd = WatchingCoinHelper.shared.list.contains(coin)
        iconView.image = nil
        nameLabel.text = ""
        subTitleLabel.text = ""
        addButton.currentButtonType = isAdd ? .buttonOkType : .buttonAddType
        addBackground.backgroundColor = isAdd ? AliceColor.green : UIColor(hex: "9A9A9A", alpha: 0.5)

        typeLabel.text = coin.type

        iconView.kf.setImage(with: coin.image) { result in
            switch result {
            case .success:
                self.typeLabel.isHidden = true
            case .failure:
                self.typeLabel.isHidden = false
            }
        }

        guard let info = coin.info else {
            return
        }

        nameLabel.text = info.name
//        iconView.kf.setImage(with: coin.image, placeholder: Constant.placeholder)
        subTitleLabel.text = info.symbol
    }
}
