//
//  AssetNFTHeaderCell.swift
//  AliceX
//
//  Created by lmcmz on 27/10/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit
import VBFPopFlatButton

class AssetNFTHeaderCell: UICollectionViewCell {
    var action: VoidBlock!

    @IBOutlet var title: UILabel!

    @IBOutlet var animationButton: VBFPopFlatButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        animationButton.currentButtonType = .buttonDownBasicType
        animationButton.currentButtonStyle = .buttonRoundedStyle
        animationButton.lineThickness = 5
        animationButton.tintColor = AliceColor.grey
        //        animationButton.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        animationButton.lineRadius = 10
    }

    func configure(count: Int, isClose: Bool) {
        animationButton.currentButtonType = isClose ? .buttonForwardType : .buttonDownBasicType

        if count <= 0 {
            return
        }

        title.text = "\(count) Collectibles"
    }

    @IBAction func hidenButtonClick() {
        action!()

        if animationButton.currentButtonType == .buttonDownBasicType {
            animationButton.currentButtonType = .buttonForwardType
        } else {
            animationButton.currentButtonType = .buttonDownBasicType
        }
    }
}
