//
//  AssetDetailChildVC.swift
//  AliceX
//
//  Created by lmcmz on 5/2/20.
//  Copyright © 2020 lmcmz. All rights reserved.
//

import JXSegmentedView
import UIKit

class AssetDetailChildVC: UIViewController {
    enum AssetTab: Int, CaseIterable {
        case transaction = 0
//        case price
        case info
    }

    var pagingView: JXPagingView!
    var userHeaderView: AssetDetailHeader!
    var segmentedViewDataSource: JXSegmentedTitleDataSource!
    var segmentedView: JXSegmentedView!
    let titles = ["Transactions", "Info"]
    var JXTableHeaderViewHeight: Int = 500
    var JXheightForHeaderInSection: Int = 50

    var detailRef: AssetDetailViewController?

    var coin: Coin!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.interactivePopGestureRecognizer?.delegate = self

        userHeaderView = AssetDetailHeader.instanceFromNib()
        userHeaderView.frame = CGRect(x: 0, y: 0, width: Constant.SCREEN_WIDTH,
                                      height: CGFloat(JXTableHeaderViewHeight))
//        userHeaderView.translatesAutoresizingMaskIntoConstraints = false
        userHeaderView.layoutIfNeeded()
        userHeaderView.configure(coin: coin)

        // segmentedViewDataSource一定要通过属性强持有！！！！！！！！！
        segmentedViewDataSource = JXSegmentedTitleDataSource()
        segmentedViewDataSource.titles = titles
        segmentedViewDataSource.titleSelectedColor = AliceColor.white()
        segmentedViewDataSource.titleNormalColor = AliceColor.darkGrey()
        segmentedViewDataSource.isTitleColorGradientEnabled = true
        segmentedViewDataSource.isItemSpacingAverageEnabled = true
        segmentedViewDataSource.reloadData(selectedIndex: 0)

        segmentedView = JXSegmentedView(frame: CGRect(x: 0, y: 0, width: Constant.SCREEN_WIDTH, height: CGFloat(JXheightForHeaderInSection)))
        segmentedView.backgroundColor = AliceColor.white()
        segmentedView.dataSource = segmentedViewDataSource
        segmentedView.isContentScrollViewClickTransitionAnimationEnabled = false

//        let indicator = JXSegmentedIndicatorLineView()
//        indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
//        indicator.lineStyle = .lengthenOffset
//        indicator.indicatorColor = AliceColor.dark
//        segmentedView.indicators = [indicator]

        let indicator = JXSegmentedIndicatorBackgroundView()
        indicator.isIndicatorConvertToItemFrameEnabled = true
        indicator.indicatorHeight = 30
        indicator.indicatorColor = AliceColor.darkGrey()
        segmentedView.indicators = [indicator]

        let lineWidth = 1 / UIScreen.main.scale
        let lineLayer = CALayer()
        lineLayer.backgroundColor = AliceColor.greyNew().cgColor
        lineLayer.frame = CGRect(x: 0, y: segmentedView.bounds.height - lineWidth, width: segmentedView.bounds.width, height: lineWidth)
        segmentedView.layer.addSublayer(lineLayer)

        pagingView = JXPagingView(delegate: self)

        view.addSubview(pagingView)
        segmentedView.contentScrollView = pagingView.listContainerView.collectionView
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        userHeaderView.frame = CGRect(x: 0, y: 0, width: Constant.SCREEN_WIDTH,
                                      height: CGFloat(JXTableHeaderViewHeight))
        pagingView.frame = view.bounds
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        view.bringSubviewToFront(pagingView)
//        view.insertSubview(userHeaderContainerView, at: 2)
//        view.insertSubview(pagingView, aboveSubview: userHeaderView)
//        view.insertSubview(<#T##view: UIView##UIView#>, belowSubview: <#T##UIView#>)
    }
}

extension AssetDetailChildVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith _: UIGestureRecognizer) -> Bool {
        return true
    }
}
