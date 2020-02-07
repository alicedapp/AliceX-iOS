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

        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture))
        addGestureRecognizer(longPress)
    }

    @objc func longPressGesture(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            UIView.animate(withDuration: 0.3) {
                self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }
            UIPasteboard.general.string = account.address
            HUDManager.shared.showSuccess(text: "Address Copied")

        case .ended:
            UIView.animate(withDuration: 0.3) {
                self.transform = CGAffineTransform.identity
            }
        default:
            break
        }
    }

    @IBAction func switchAccount() {
        WalletManager.switchAccount(account: account)
    }

    func configure(account: Account) {
        self.account = account

        nameLabel.text = account.name
        addressLabel.text = account.address
        iconView.image = UIImage(named: account.imageName)

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
