//
//  MiniAppAddCell.swift
//  AliceX
//
//  Created by lmcmz on 22/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit
import VBFPopFlatButton

class MiniAppAddCell: UICollectionViewCell {

    @IBOutlet var shadowView: UIView!
//    @IBOutlet var addButton: VBFPopFlatButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        addButton.currentButtonStyle = .buttonRoundedStyle
//        addButton.currentButtonType = .buttonAddType
//        addButton.tintColor = .white
//        addButton.lineRadius = 8
//        addButton.lineThickness = 5
    }
    
    func setup() {
        layoutIfNeeded()
//        iconView.layer.cornerRadius = iconView.bounds.height / 2
//        addButton.layer.cornerRadius = shadowView.bounds.height / 2

//        colorView.layer.cornerRadius = colorView.bounds.height / 2
        
        shadowView.layer.shadowColor = UIColor(hex: "#000000", alpha: 0.5).cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        shadowView.layer.shadowOpacity = 0.3
        shadowView.layer.shadowRadius = 5
    }

    func configure(item: HomeItem) {
        setup()
    }

}
