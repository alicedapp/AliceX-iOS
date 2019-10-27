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
    
    @IBOutlet var coinImageView: UIImageView!
    @IBOutlet var animationButton: VBFPopFlatButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        animationButton.currentButtonType = .buttonForwardType
        animationButton.currentButtonStyle = .buttonRoundedStyle
        animationButton.lineThickness = 2
        animationButton.tintColor = UIColor(hex: "ADF157")
        animationButton.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
    }
    
    func configure() {
//        coinImageView.kf.setImage(with: <#T##ImageDataProvider?#>)
    }

}
