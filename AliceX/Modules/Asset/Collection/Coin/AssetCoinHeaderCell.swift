//
//  AssetCoinHeaderCell.swift
//  AliceX
//
//  Created by lmcmz on 27/10/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import SPStorkController
import UIKit
import VBFPopFlatButton

class AssetCoinHeaderCell: UICollectionViewCell {
    var action: VoidBlock!

    @IBOutlet var animationButton: VBFPopFlatButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        animationButton.currentButtonType = .buttonDownBasicType
        animationButton.currentButtonStyle = .buttonRoundedStyle
        animationButton.lineThickness = 5
        animationButton.tintColor = AliceColor.lightGrey
//        animationButton.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        animationButton.lineRadius = 10
    }

    @IBAction func addButtonClick() {
        let vc = CoinListViewController()
        vc.isFromPopup = true
        let topVC = UIApplication.topViewController()
        let navi = BaseNavigationController(rootViewController: vc)
        let transitionDelegate = SPStorkTransitioningDelegate()
        navi.transitioningDelegate = transitionDelegate
        navi.modalPresentationStyle = .custom
        topVC!.presentAsStork(navi, height: nil, showIndicator: false, showCloseButton: false)
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
