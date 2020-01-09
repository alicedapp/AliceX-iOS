//
//  SwitchAccountLarkCell.swift
//  AliceX
//
//  Created by lmcmz on 8/1/20.
//  Copyright © 2020 lmcmz. All rights reserved.
//

import UIKit

class SwitchAccountLarkCell: UICollectionViewCell {

    @IBOutlet var selectView: UIView!
    @IBOutlet var indicatorView: UIView!
    
    @IBOutlet var iconView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    
    var account: Account!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func switchAccount() {
        WalletManager.switchAccount(account: account)
    }
    
    func configure(account: Account) {
        
        self.account = account
        
        nameLabel.text = account.name
        addressLabel.text = account.address
        iconView.image = UIImage.init(named: account.imageName)
        
        if WalletManager.currentAccount! == account {
            selectView.isHidden = false
            indicatorView.isHidden = false
            addressLabel.textColor = UIColor.systemGreen
        } else {
            selectView.isHidden = true
            indicatorView.isHidden = true
            addressLabel.textColor = AliceColor.greyNew()
        }
    }

}
