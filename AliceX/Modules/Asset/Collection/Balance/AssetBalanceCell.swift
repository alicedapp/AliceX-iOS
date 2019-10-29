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

class AssetBalanceCell: UICollectionViewCell {
    @IBOutlet var currencyButton: BaseControl!
    @IBOutlet var hideButton: BaseControl!
    @IBOutlet var animationButton: VBFPopFlatButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        let type = animationButton.currentButtonType == FlatButtonType.buttonRewindType ? FlatButtonType.buttonFastForwardType : FlatButtonType.buttonRewindType
        animationButton.animate(to: type)
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
}
