//
//  WalletImageCell.swift
//  AliceX
//
//  Created by lmcmz on 10/1/20.
//  Copyright © 2020 lmcmz. All rights reserved.
//

import UIKit

class WalletImageCell: UICollectionViewCell {

    @IBOutlet var iconImage: UIImageView!
    @IBOutlet var textLabel: UILabel!
    
    @IBOutlet var selectView: UIView!
    
    @IBOutlet var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(name: String, account: Account) {
        
        selectView.isHidden = !(account.imageName == name)
        
        iconImage.image = UIImage(named: name)
        textLabel.text = name.firstUppercased
        
        if account.imageName == name {
            containerView.layer.borderColor = UIColor.systemGreen.cgColor
            containerView.layer.borderWidth = 1
        } else {
            containerView.layer.borderColor = UIColor.clear.cgColor
        }
    }
}
