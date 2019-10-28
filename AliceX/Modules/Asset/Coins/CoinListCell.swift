//
//  CoinListCell.swift
//  AliceX
//
//  Created by lmcmz on 28/10/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit
import VBFPopFlatButton
import Kingfisher

class CoinListCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var iconView: UIImageView!
    @IBOutlet var addButton: VBFPopFlatButton!
    @IBOutlet var coinShadow: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addButton.currentButtonStyle = .buttonRoundedStyle
        addButton.currentButtonType = .buttonAddType
        addButton.tintColor = .white
        addButton.lineRadius = 5
        addButton.lineThickness = 2
        
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
    
    func configure(chain: BlockChain) {
        
        nameLabel.text = chain.rawValue
        iconView.kf.setImage(with: Coin.blockchain(chain).image, placeholder: Constant.placeholder)
        
        guard let info = chain.data else {
            return
        }

    }
    
}
