//
//  AssetDetailViewController+Segement.swift
//  AliceX
//
//  Created by lmcmz on 4/2/20.
//  Copyright © 2020 lmcmz. All rights reserved.
//

import Foundation
import JXSegmentedView
import PromiseKit

extension AssetDetailViewController: JXSegmentedListContainerViewDataSource {
    func listContainerView(_: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        let vc = AssetDetailChildVC()
        vc.coin = coins[index]
        vc.detailRef = self
        vc.view.backgroundColor = .random
        return vc
    }
}

extension AssetDetailViewController: JXSegmentedViewDelegate {
    func segmentedView(_: JXSegmentedView, didSelectedItemAt index: Int) {
        currentCoin = coins[index]
    }

    func segmentedView(_: JXSegmentedView, didScrollSelectedItemAt _: Int) {}

    func numberOfLists(in _: JXSegmentedListContainerView) -> Int {
        return coins.count
    }
}

extension AssetDetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith _: UIGestureRecognizer) -> Bool {
        return true
    }
}
