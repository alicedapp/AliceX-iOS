//
//  AssetDetailHeader.swift
//  AliceX
//
//  Created by lmcmz on 5/2/20.
//  Copyright © 2020 lmcmz. All rights reserved.
//

import UIKit
import JXSegmentedView

class AssetDetailHeader: BaseView {
    
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var segmentedContainer: UIView!
    
    @IBOutlet var coinImageView: UIImageView!
    @IBOutlet var coinNameLabel: UILabel!
    @IBOutlet var coinSymbolLabel: UILabel!
    @IBOutlet var coinTypeLabel: UILabel!
    
    var segmentedViewDataSource: JXSegmentedTitleDataSource!
    var segmentedView: JXSegmentedView!
    let titles = ["1D", "1W", "1M", "3M", "6M", "1Y"]

    override class func instanceFromNib() -> AssetDetailHeader {
        let view = UINib(nibName: nameOfClass, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! AssetDetailHeader
//        view.configure()
        view.isHeroEnabledForSubviews = true
        view.isHeroEnabled = true
        return view
    }

    func scrollViewDidScroll(contentOffsetY: CGFloat) {
        var frame = self.frame
        frame.size.height -= contentOffsetY
        frame.origin.y = contentOffsetY
        self.frame = frame
    }
    
    override func awakeFromNib() {
         segmentedViewDataSource = JXSegmentedTitleDataSource()
        segmentedViewDataSource.titles = titles
        segmentedViewDataSource.titleSelectedColor = AliceColor.white()
        segmentedViewDataSource.titleNormalColor = AliceColor.darkGrey()
        segmentedViewDataSource.isTitleColorGradientEnabled = true
//        segmentedViewDataSource.isTitleZoomEnabled = true
        segmentedViewDataSource.reloadData(selectedIndex: 0)

        segmentedView = JXSegmentedView()
        segmentedView.backgroundColor = AliceColor.white()
        segmentedView.dataSource = segmentedViewDataSource
        segmentedView.isContentScrollViewClickTransitionAnimationEnabled = false
        
        segmentedContainer.addSubview(segmentedView)
        segmentedView.fillSuperview()
        
        let indicator = JXSegmentedIndicatorBackgroundView()
       indicator.isIndicatorConvertToItemFrameEnabled = true
       indicator.indicatorHeight = 30
       indicator.indicatorColor = AliceColor.darkGrey()
       segmentedView.indicators = [indicator]
    }

    func configure(coin: Coin) {
        coinImageView.kf.setImage(with: coin.image)
        coinNameLabel.text = coin.info?.name
        coinSymbolLabel.text = coin.info?.symbol
        coinTypeLabel.text = coin.isERC20 ? "ERC20" : "Coin"
    }
}

extension AssetDetailHeader: JXSegmentedViewDelegate {
    
    func segmentedView(_: JXSegmentedView, didSelectedItemAt index: Int) {
//        currentCoin = coins[index]
    }

    func numberOfLists(in _: JXSegmentedListContainerView) -> Int {
        return titles.count
    }
}
