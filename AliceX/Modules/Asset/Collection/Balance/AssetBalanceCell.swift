//
//  AssetBalanceCell.swift
//  AliceX
//
//  Created by lmcmz on 27/10/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit
import VBFPopFlatButton

class AssetBalanceCell: UICollectionViewCell {

    @IBOutlet var currencyButton: BaseControl!
    @IBOutlet var hideButton: BaseControl!
    @IBOutlet var animationButton: VBFPopFlatButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let type = self.animationButton.currentButtonType == FlatButtonType.buttonRewindType ? FlatButtonType.buttonFastForwardType : FlatButtonType.buttonRewindType
        self.animationButton.animate(to: type)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        hideButton.roundCorners(corners: [.topLeft], radius: 20)
        currencyButton.roundCorners(corners: [.topRight], radius: 20)
        
        animationButton.currentButtonType = .buttonFastForwardType
        animationButton.currentButtonStyle = .buttonPlainStyle
        animationButton.lineThickness = 5
        animationButton.tintColor = UIColor(hex: "ADF157")
        animationButton.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
    }

}
