//
//  AssetBalanceCell.swift
//  AliceX
//
//  Created by lmcmz on 27/10/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import SPLarkController
import SPStorkController
import SwiftyUserDefaults
import UIKit
import VBFPopFlatButton

class AssetBalanceCell: UICollectionViewCell {
    var action: VoidBlock!

    @IBOutlet var currencyLabel: UILabel!
    @IBOutlet var hideLabel: UILabel!

    @IBOutlet var balanceLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!

    @IBOutlet var accountImage: UIImageView!
    @IBOutlet var accountButton: BaseControl!

    @IBOutlet var currencyButton: BaseControl!
    @IBOutlet var hideButton: BaseControl!
    @IBOutlet var animationButton: VBFPopFlatButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        animationButton.currentButtonType = .buttonPausedType
        animationButton.currentButtonStyle = .buttonRoundedStyle
        animationButton.lineThickness = 5
        animationButton.tintColor = UIColor(hex: "ADF157")
        animationButton.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        animationButton.lineRadius = 10

        let balance = Defaults[\.lastAssetBalance].toString(decimal: 2)
        balanceLabel.text = balance
        currencyLabel.text = PriceHelper.shared.currentCurrency.rawValue
    }

    @IBAction func accountButtonClick() {
        let controller = SwitchAccountLarkController()
        let transitionDelegate = SPLarkTransitioningDelegate()
        transitionDelegate.customHeight = 180
        controller.transitioningDelegate = transitionDelegate
        controller.modalPresentationStyle = .custom
        controller.modalPresentationCapturesStatusBarAppearance = true
        UIApplication.topViewController()!.present(controller, animated: true, completion: nil)
    }

    @IBAction func hidenButtonClick() {
        if action == nil {
            return
        }
        action!()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        hideButton.roundCorners(corners: [.topLeft], radius: 20)
        currencyButton.roundCorners(corners: [.topRight], radius: 20)
        accountButton.roundCorners(corners: [.bottomLeft], radius: 20)
    }

    @IBAction func currencyButtonClick() {
        let vc = CurrencyViewController()
        vc.isFromPopup = true
        let topVC = UIApplication.topViewController()
        let navi = BaseNavigationController(rootViewController: vc)
        let transitionDelegate = SPStorkTransitioningDelegate()
        navi.transitioningDelegate = transitionDelegate
        navi.modalPresentationStyle = .custom
        topVC!.presentAsStork(navi, height: nil, showIndicator: false, showCloseButton: false)
    }

    func configure(isHidden: Bool, newBalance: Double) {
        accountButton.isHidden = !(WalletManager.Accounts!.count > 1)
        accountImage.image = UIImage(named: WalletManager.currentAccount!.imageName)

        currencyLabel.text = PriceHelper.shared.currentCurrency.rawValue
        hideLabel.text = isHidden ? "Show" : "Hide"
//            "🐵" : "🙈"

        let oldBalance = Defaults[\.lastAssetBalance]
        if newBalance >= oldBalance {
            animationButton.currentButtonType = FlatButtonType.buttonFastForwardType
            animationButton.tintColor = AliceColor.green
        } else {
            animationButton.currentButtonType = FlatButtonType.buttonRewindType
            animationButton.tintColor = AliceColor.red
        }

        if let date = Defaults[\.lastTimeUpdateAsset] {
            let timeStr = Date.getTimeComponentString(olderDate: date, newerDate: Date())
            timeLabel.text = timeStr == "Just now" ? "Just now" : "\(timeStr!) ago"
        } else {
            timeLabel.text = ""
        }

        if isHidden {
            balanceLabel.text = "***"
//            "🙉🙈🙊"
            return
        }

        balanceLabel.text = newBalance.toString(decimal: 2)
    }
}
