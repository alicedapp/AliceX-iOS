//
//  AssetBalanceCell.swift
//  AliceX
//
//  Created by lmcmz on 27/10/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import SPLarkController
import SPStorkController
import UIKit
import VBFPopFlatButton
import SwiftyUserDefaults

class AssetBalanceCell: UICollectionViewCell {
    var action: VoidBlock!
    
    @IBOutlet var currencyLabel: UILabel!
    @IBOutlet var hideLabel: UILabel!
    
    @IBOutlet var balanceLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var currencyButton: BaseControl!
    @IBOutlet var hideButton: BaseControl!
    @IBOutlet var animationButton: VBFPopFlatButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        let type = animationButton.currentButtonType == FlatButtonType.buttonRewindType ? FlatButtonType.buttonFastForwardType : FlatButtonType.buttonRewindType
        animationButton.animate(to: type)
        
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
        animationButton.currentButtonType = .buttonFastForwardType
        animationButton.currentButtonStyle = .buttonRoundedStyle
        animationButton.lineThickness = 5
        animationButton.tintColor = UIColor(hex: "ADF157")
        animationButton.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        animationButton.lineRadius = 10
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
    
    func configure(isHidden: Bool) {
        currencyLabel.text = PriceHelper.shared.currentCurrency.flag
        hideLabel.text = isHidden ? "🐵" : "🙈"
        
        if let date = Defaults[\.lastTimeUpdateAsset] {
            let timeStr = Date.getTimeComponentString(olderDate: date, newerDate: Date())
            timeLabel.text = timeStr == "Just now" ? "Just now" : "\(timeStr!) ago"
        } else {
            timeLabel.text = ""
        }
        
        if isHidden {
            balanceLabel.text = "🙈🙉🙊"
            return
        }
        
        var balance = 0.0
        for coin in WatchingCoinHelper.shared.list {
            guard let info = coin.info else {
                continue
            }
            balance += info.balance
        }
        balanceLabel.text = balance.toString(decimal: 2)
    }
    
}
