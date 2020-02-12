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
    @IBOutlet var balanceChangeLabel: UILabel!
    @IBOutlet var segmentedContainer: UIView!
    
    @IBOutlet var coinImageView: UIImageView!
    @IBOutlet var coinNameLabel: UILabel!
    @IBOutlet var coinSymbolLabel: UILabel!
    @IBOutlet var coinTypeLabel: UILabel!
    
    @IBOutlet var chartView: BEMSimpleLineGraphView!
    
    @IBOutlet var closeLabel: UILabel!
    @IBOutlet var openLabel: UILabel!
    @IBOutlet var HighLabel: UILabel!
    @IBOutlet var lowLabel: UILabel!
    @IBOutlet var volFromLabel: UILabel!
    @IBOutlet var volToLabel: UILabel!
    @IBOutlet var supplyLabel: UILabel!
    @IBOutlet var mktcapLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var marketLabel: UILabel!
    
    @IBOutlet var loadingView: UIView!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    
    var segmentedViewDataSource: JXSegmentedTitleDataSource!
    var segmentedView: JXSegmentedView!

    var coin: Coin! = .coin(chain: .Ethereum)
    var data = [CryptocompareHistoryData]()
    
    var currentPeriod: Period = Period.oneDay
    
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
        segmentedViewDataSource.titles = Period.allCases.compactMap{ $0.text }
        segmentedViewDataSource.titleSelectedColor = AliceColor.white()
        segmentedViewDataSource.titleNormalColor = AliceColor.darkGrey()
        segmentedViewDataSource.isTitleColorGradientEnabled = true
//        segmentedViewDataSource.isTitleZoomEnabled = true
        segmentedViewDataSource.reloadData(selectedIndex: 0)

        segmentedView = JXSegmentedView()
        segmentedView.backgroundColor = AliceColor.white()
        segmentedView.dataSource = segmentedViewDataSource
        segmentedView.isContentScrollViewClickTransitionAnimationEnabled = false
        segmentedView.delegate = self
        
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
        
        marketLabel.text = info.market?.lastMarket
        
        coinImageView.kf.setImage(with: coin.image)
        coinNameLabel.text = info.name
        coinSymbolLabel.text = info.symbol
        coinTypeLabel.text = coin.isERC20 ? "ERC20" : "Coin"
        
        priceLabel.text = info.price?.currencyString
        if let change = info.changeIn24HPercentage {
           if change > 0.0 {
               precentageLabel.textColor = UIColor.systemGreen
               let precentage = change.toString(decimal: 3)
               if precentage != "0" {
                   precentageLabel.text = "+\(precentage)%"
               } else {
                   precentageLabel.text = ""
               }
               
           } else {
               precentageLabel.textColor = AliceColor.red
               let precentage = change.toString(decimal: 3)
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
            
            if let changePrice = info.changeIn24H {
                if changePrice > 0.0 {
                    balanceChangeLabel.textColor = UIColor.systemGreen
                    balanceChangeLabel.text = "+ \(currencySymbol)\((amountInDouble*changePrice).toString(decimal: 3))"
                } else {
                    balanceChangeLabel.textColor = AliceColor.red
                    balanceChangeLabel.text = "- \(currencySymbol)\((amountInDouble*changePrice).toString(decimal: 3))"
                }
            }
            
        } else {
            amountLabel.text = "0 \(info.symbol!)"
            balanceLabel.text = "\(currencySymbol) 0"
        }
        
        setupChartView()
        
        guard let market = info.market else {
            return
        }
        
        openLabel.text = market.open24H.toString(decimal: 3)
        HighLabel.text = market.high24H.toString(decimal: 3)
        lowLabel.text = market.low24H.toString(decimal: 3)
        closeLabel.text = info.price!.toString(decimal: 3)
        
        mktcapLabel.text = market.MKTCAP.intValue.formatUsingAbbrevation()
        supplyLabel.text = market.supply.intValue.formatUsingAbbrevation()
        volFromLabel.text = market.vol24H.intValue.delimiter
        volToLabel.text = market.volTo24H.intValue.delimiter
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy 'at' HH:mm"
        let date = Date(timeIntervalSince1970: market.lastUpdate)
        timeLabel.text = dateFormatter.string(from: date)
    }
    
    @IBAction func viewOnClick() {
        let url = "https://www.coinbase.com/price/\(coin.info!.symbol!.lowercased())"
        let vc = BrowserWrapperViewController.make(urlString: url)
        let topVC = UIApplication.topViewController()
        topVC?.navigationController?.pushViewController(vc, animated: true)
    }
}

extension AssetDetailHeader: JXSegmentedViewDelegate {
    
    func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) {
        currentPeriod = Period.allCases[index]
        requestData()
    }

    func numberOfLists(in _: JXSegmentedListContainerView) -> Int {
        return Period.allCases.count
    }
}
