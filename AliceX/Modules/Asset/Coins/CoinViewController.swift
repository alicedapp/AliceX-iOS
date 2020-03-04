//
//  CoinViewController.swift
//  AliceX
//
//  Created by lmcmz on 2/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import JXSegmentedView
import UIKit

class CoinViewController: BaseViewController {
    @IBOutlet var segmentedContainer: UIView!
    @IBOutlet var container: UIView!

    var dataSource: JXSegmentedTitleDataSource!
    var segmentedView = JXSegmentedView()
    var listContainerView: JXSegmentedListContainerView!

    var tabs = ["Coins", "Watched", "Ignored"]

    override func viewDidLoad() {
        super.viewDidLoad()

        segmentedView.delegate = self
        segmentedContainer.addSubview(segmentedView)

        dataSource = JXSegmentedTitleDataSource()
        dataSource.titleNormalColor = AliceColor.greyNew()
        dataSource.titleSelectedColor = AliceColor.darkGrey()
        dataSource.isTitleColorGradientEnabled = true
        dataSource.titles = tabs
        segmentedView.dataSource = dataSource

        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
        indicator.lineStyle = .lengthenOffset
        indicator.indicatorColor = AliceColor.darkGrey()
        segmentedView.indicators = [indicator]

        listContainerView = JXSegmentedListContainerView(dataSource: self, type: .scrollView)
        segmentedView.listContainer = listContainerView

        container.addSubview(listContainerView)
        segmentedView.fillSuperview()
        listContainerView.fillSuperview()
    }
}

extension CoinViewController: JXSegmentedListContainerViewDataSource, JXSegmentedViewDelegate {
    func numberOfLists(in _: JXSegmentedListContainerView) -> Int {
        return tabs.count
    }

    func listContainerView(_: JXSegmentedListContainerView, initListAt _: Int) -> JXSegmentedListContainerViewListDelegate {
//        let chain = chains[index]
        let vc = CoinListViewController()
//        var data: [CoinInfo] = []
//        switch index {
//        case 0:
        ////            WatchingHelper.shared.
//            data = BlockChain.allCases.compactMap { $0.info }
//        case 1:
//            data = WatchingCoinHelper.shared.list
//        case 2:
//            data = WatchingCoinHelper.shared.list
//        default:
//            break
//        }
//        vc.data = data
//        let view = BlockChainQRCodeView.instanceFromNib()
//        view.chain = chain
//        view.configure()
//        vc.view.addSubview(view)
//        view.fillSuperview()
//        view.layoutIfNeeded()
        return vc
    }
}
