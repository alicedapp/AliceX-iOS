//
//  AssetCoinCell.swift
//  AliceX
//
//  Created by lmcmz on 27/10/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit
import Kingfisher
import VBFPopFlatButton

class AssetCoinCell: UICollectionViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var balanceLabel: UILabel!
    
    @IBOutlet var coinShadow: UIView!
    @IBOutlet var coinImageView: UIImageView!
    @IBOutlet var animationButton: VBFPopFlatButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: coinShadow.bounds, cornerRadius: 25).cgPath
        shadowLayer.fillColor = UIColor.white.cgColor
        shadowLayer.shadowColor = UIColor(hex: "#000000", alpha: 0.5).cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0, height: 1.0)
        shadowLayer.shadowOpacity = 0.3
        shadowLayer.shadowRadius = 5
        coinShadow.layer.insertSublayer(shadowLayer, at: 1)
        
        animationButton.currentButtonType = .buttonUpBasicType
        animationButton.currentButtonStyle = .buttonRoundedStyle
        animationButton.lineThickness = 2
        animationButton.lineRadius = 2
        animationButton.tintColor = UIColor(hex: "ADF157")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func configure(item: TokenArrayItem) {
        guard let info = item.tokenInfo else {
            return
        }
        nameLabel.text = info.name
        let num = pow(Double(10.0), Double(info.decimals))
        let amount = Double(item.balance/num)
        amountLabel.text = "\(amount.toString(decimal: 3)) \(info.symbol!)"
        
        if let price = info.price {
            priceLabel.text = "$ \(Double(price.rate).toString(decimal: 3))"
            balanceLabel.text = "$ \((amount * Double(price.rate)).toString(decimal: 3))"
        }
        
        let address = info.address
        coinImageView.kf.setImage(with: Coin.ERC20(address!).image, placeholder: Constant.placeholder)
    }
    
    func configure(item: BlockChain) {
        
        nameLabel.text = item.rawValue
        coinImageView.kf.setImage(with: Coin.blockchain(item).image, placeholder: Constant.placeholder)
        amountLabel.text = ""
        priceLabel.text = ""
        balanceLabel.text = ""
        
        guard let info = item.data else {
            return
        }
        
        priceLabel.text = "$ \(info.quote!.USD!.price!.toString(decimal: 3))"
        if Double(info.quote!.USD!.percent_change_24h!) > 0.0 {
            animationButton.currentButtonType = .buttonUpBasicType
        } else {
            animationButton.currentButtonType = .buttonDownBasicType
        }
    }
}
