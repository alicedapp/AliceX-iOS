//
//  AssetDetailHeader.swift
//  AliceX
//
//  Created by lmcmz on 5/2/20.
//  Copyright © 2020 lmcmz. All rights reserved.
//

import UIKit
import JXSegmentedView
import BigInt
import web3swift

class AssetDetailHeader: BaseView {
    
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var balanceLabel: UILabel!
    @IBOutlet var precentageLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var segmentedContainer: UIView!
    
    @IBOutlet var coinImageView: UIImageView!
    @IBOutlet var coinNameLabel: UILabel!
    @IBOutlet var coinSymbolLabel: UILabel!
    @IBOutlet var coinTypeLabel: UILabel!
    
    @IBOutlet var chartView: BEMSimpleLineGraphView!
    
    @IBOutlet var openLabel: UILabel!
    @IBOutlet var HighLabel: UILabel!
    @IBOutlet var lowLabel: UILabel!
    @IBOutlet var volLabel: UILabel!
    @IBOutlet var supplyLabel: UILabel!
    @IBOutlet var mktcapLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    var segmentedViewDataSource: JXSegmentedTitleDataSource!
    var segmentedView: JXSegmentedView!
    let titles = ["1D", "1W", "1M", "3M", "1Y", "All"]

    var coin: Coin! = .coin(chain: .Ethereum)
    var data = [CryptocompareHistoryData]()
    
    var gradient: CGGradient!
    
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
        self.coin = coin
        
        guard let info = coin.info else {
            HUDManager.shared.showError(text: "Empty Info")
            return
        }
        
        coinImageView.kf.setImage(with: coin.image)
        coinNameLabel.text = info.name
        coinSymbolLabel.text = info.symbol
        coinTypeLabel.text = coin.isERC20 ? "ERC20" : "Coin"
        
        priceLabel.text = info.price?.currencyString
        if let change = info.changeIn24H {
           if change > 0.0 {
               precentageLabel.textColor = UIColor.systemGreen
               let precentage = change.toString(decimal: 5)
               if precentage != "0" {
                   precentageLabel.text = "+\(precentage)%"
               } else {
                   precentageLabel.text = ""
               }
               
           } else {
               precentageLabel.textColor = AliceColor.red
               let precentage = change.toString(decimal: 5)
               if precentage != "-0" {
                   precentageLabel.text = "\(precentage)%"
               } else {
                   precentageLabel.text = ""
               }
           }
       }
        
        let currencySymbol = PriceHelper.shared.currentCurrency.symbol
        
        if let balance = info.amount, let balanceInt = BigUInt(balance),
            let amount = Web3.Utils.formatToPrecision(balanceInt, numberDecimals: info.decimals, formattingDecimals: 4, decimalSeparator: ".", fallbackToScientific: false), let amountInDouble = Double(amount) {
            let removeZero = String(format: "%g", amountInDouble)
            amountLabel.text = "\(removeZero) \(info.symbol!)"

            if let price = info.price, let doubleAmount = Double(amount) {
                balanceLabel.text = "\(currencySymbol) \((doubleAmount * price).toString(decimal: 3))"
            }
        } else {
            amountLabel.text = "0 \(info.symbol!)"
            balanceLabel.text = "\(currencySymbol) 0"
        }
        
        setupChartView()
        
        guard let market = info.market else {
            return
        }
        
        openLabel.text = String(market.open24H)
        HighLabel.text = String(market.high24H)
        lowLabel.text = String(market.low24H)
        
        mktcapLabel.text = String(market.MKTCAP.doubleValue)
        supplyLabel.text = String(market.supply)
        volLabel.text = String(market.vol24H)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy '\n' HH:mm"
        let date = Date(timeIntervalSince1970: market.lastUpdate)
        timeLabel.text = dateFormatter.string(from: date)
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
