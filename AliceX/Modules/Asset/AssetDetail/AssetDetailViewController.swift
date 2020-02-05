//
//  AssetDetailViewController.swift
//  AliceX
//
//  Created by lmcmz on 19/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import JXSegmentedView
import UIKit

class AssetDetailViewController: BaseViewController {
    @IBOutlet var segmentedContainer: UIView!
    @IBOutlet var container: UIView!
//    @IBOutlet var chartContainer: UIView!
//    @IBOutlet var chartView: BEMSimpleLineGraphView!

    var gradient: CGGradient?
    var lineGradient: CGGradient?

    var dataSource: JXSegmentedTitleImageDataSource!
    var segmentedView = JXSegmentedView()
    var listContainerView: JXSegmentedListContainerView!

    var coins: [Coin] = WatchingCoinHelper.shared.list

    var data = [Coin: [AmberdataPricePoint?]]()

    var currentCoin: Coin = .coin(chain: .Ethereum) {
        didSet {
            if currentCoin != oldValue {
//                requestData()
            }
        }
    }

    var pagingView: JXPagingView!
    var userHeaderView: AssetDetailHeader!
    var userHeaderContainerView: UIView!

    var JXTableHeaderViewHeight: Int = 200
    var JXheightForHeaderInSection: Int = 50

    override func viewDidLoad() {
        super.viewDidLoad()

        userHeaderContainerView = UIView(frame: CGRect(x: 0, y: 0, width: Constant.SCREEN_WIDTH,
                                                       height: CGFloat(JXTableHeaderViewHeight)))
        userHeaderView = AssetDetailHeader.instanceFromNib()
        userHeaderContainerView.addSubview(userHeaderView)
        userHeaderView.fillSuperview()

//        segmentedView.delegate = self
        segmentedContainer.addSubview(segmentedView)

        dataSource = JXSegmentedTitleImageDataSource()
        dataSource.titleNormalColor = AliceColor.darkGrey()
        dataSource.titleSelectedColor = AliceColor.white()
        dataSource.isTitleColorGradientEnabled = true
        dataSource.titleImageType = .leftImage
        dataSource.isImageZoomEnabled = false
        dataSource.titles = coins.compactMap { $0.info?.symbol }
        dataSource.normalImageInfos = coins.compactMap { $0.image.absoluteString }
        dataSource.imageSize = CGSize(width: 15, height: 15)
        dataSource.loadImageClosure = { imageView, normalImageInfo in
            imageView.kf.setImage(with: URL(string: normalImageInfo), placeholder: Constant.placeholder)
        }

        segmentedView.dataSource = dataSource

//        let indicator = JXSegmentedIndicatorDotLineView()
//       indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
//       indicator.lineStyle = .lengthenOffset

        let indicator = JXSegmentedIndicatorBackgroundView()
        indicator.isIndicatorConvertToItemFrameEnabled = true
        indicator.indicatorHeight = 30
        indicator.indicatorColor = AliceColor.darkGrey()
        segmentedView.indicators = [indicator]

//        listContainerView = JXSegmentedListContainerView(dataSource: self, type: .collectionView)
//        segmentedView.listContainer = listContainerView

        pagingView = JXPagingView(delegate: self)
        container.addSubview(pagingView)
        segmentedView.contentScrollView = pagingView.listContainerView.collectionView

//        container.addSubview(listContainerView)
        segmentedView.fillSuperview()
        pagingView.fillSuperview()

//       if let index = chains.firstIndex(of: selectBlockCahin) {
//           segmentedView.defaultSelectedIndex = index
//       }
//        setupChartView()
//        requestData()
    }
}
