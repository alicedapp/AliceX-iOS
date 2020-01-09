//
//  SwitchAccountCell.swift
//  AliceX
//
//  Created by lmcmz on 5/1/20.
//  Copyright © 2020 lmcmz. All rights reserved.
//

import UIKit
import FoldingCell

class SwitchAccountCell: FoldingCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var upImageView: UIImageView!
    @IBOutlet var downImageView: UIImageView!
    @IBOutlet var nameField: UITextField!
    
    @IBOutlet var indicator: UIImageView!
    @IBOutlet var selectView: UIView!
    
    var account: Account!
//    @IBOutlet var : UITextField!
    
    override func awakeFromNib() {
//        foregroundView.layer.cornerRadius = 10
//        foregroundView.layer.masksToBounds = true
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func animationDuration(_ itemIndex: NSInteger, type _: FoldingCell.AnimationType) -> TimeInterval {
        let durations = [0.1, 0.1, 0.1]
        return durations[itemIndex]
    }
    
    @IBAction func switchAccount() {
        WalletManager.switchAccount(account: account)
    }
    
    func configure(account: Account) {
        
        self.account = account
        
        nameLabel.text = account.name
        addressLabel.text = account.address
        nameField.text = account.name
        upImageView.image = UIImage(named: account.imageName)
        downImageView.image = UIImage(named: account.imageName)
        
        if account == WalletManager.currentAccount! {
            foregroundView.layer.borderColor = UIColor.systemGreen.cgColor
            foregroundView.layer.borderWidth = 1
            indicator.image = indicator.image?.filled(with: UIColor.systemGreen)
            selectView.isHidden = false
            addressLabel.textColor = UIColor.systemGreen
        } else {
            foregroundView.layer.borderWidth = 0
            indicator.image = indicator.image?.filled(with: AliceColor.greyNew())
            selectView.isHidden = true
            addressLabel.textColor = AliceColor.greyNew()
        }
    }
}
