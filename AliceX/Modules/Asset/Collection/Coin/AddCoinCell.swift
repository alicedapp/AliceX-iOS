//
//  AddCoinCell.swift
//  AliceX
//
//  Created by lmcmz on 12/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit

class AddCoinCell: UICollectionViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func addButtonClick() {
        let vc = CoinListViewController()
        //        vc.isFromPopup = true
        let topVC = UIApplication.topViewController()
        //        let navi = BaseNavigationController(rootViewController: vc)
        //        let transitionDelegate = SPStorkTransitioningDelegate()
        //        navi.transitioningDelegate = transitionDelegate
        //        navi.modalPresentationStyle = .custom
        //        topVC!.presentAsStork(navi, height: nil, showIndicator: false, showCloseButton: false)

        topVC?.presentAsStork(vc, height: nil, showIndicator: false, showCloseButton: false)
    }
}
