//
//  SwitchAccountCell.swift
//  AliceX
//
//  Created by lmcmz on 5/1/20.
//  Copyright © 2020 lmcmz. All rights reserved.
//

import FoldingCell
import UIKit

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

        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture))
        foregroundView.addGestureRecognizer(longPress)
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func animationDuration(_ itemIndex: NSInteger, type _: FoldingCell.AnimationType) -> TimeInterval {
        let durations = [0.1, 0.1]
        return durations[itemIndex]
    }

    @IBAction func switchAccount() {
        WalletManager.switchAccount(account: account)
    }

    @IBAction func walletImageButton() {
        let vc = WalletAvatarViewController.make(account: account)
        UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
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
