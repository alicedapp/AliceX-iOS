
//  AssetDetailHeader+Chart.swift
//  AliceX

//  Created by lmcmz on 10/2/20.
//  Copyright © 2020 lmcmz. All rights reserved.


import Foundation
import PromiseKit

 extension AssetDetailHeader: BEMSimpleLineGraphDataSource {
    
    enum Period: CaseIterable {
        case oneDay
        case oneWeek
        case oneMonth
        case threeMonths
        case oneYear
        case all
        
        var text: String {
            switch self {
            case .oneDay:
                return "24H"
            case .oneWeek:
                return "1W"
            case .oneMonth:
                return "1M"
            case .threeMonths:
                return "3M"
            case .oneYear:
                return "1Y"
            case .all:
                return "All"
            }
        }
        
        
        func requestMethod(symbol: String) -> Promise<CryptocompareHistoryModel> {
            let currentCurrency = PriceHelper.shared.currentCurrency
            switch self {
            case .oneDay:
                return API(Cryptocompare.historyHour(symbol: symbol,
                                                     currency: currentCurrency,
                                                     limit: 24), path: "Data")
            case .oneWeek:
                return API(Cryptocompare.historyHour(symbol: symbol,
                                              currency: PriceHelper.shared.currentCurrency,
                                              limit: 7*24), path: "Data")
            case .oneMonth:
                return API(Cryptocompare.historyDay(symbol: symbol,
                                             currency: PriceHelper.shared.currentCurrency,
                                             limit: 30, allData: false), path: "Data")
            case .threeMonths:
                return API(Cryptocompare.historyDay(symbol: symbol,
                                                    currency: PriceHelper.shared.currentCurrency,
                                                    limit: 30 * 3,
                                                    allData: false), path: "Data")
            case .oneYear:
                return API(Cryptocompare.historyDay(symbol: symbol,
                                                    currency: PriceHelper.shared.currentCurrency,
                                                    limit: 365, allData: false), path: "Data")
            case .all:
                return API(Cryptocompare.historyDay(symbol: symbol,
                                             currency: PriceHelper.shared.currentCurrency,
                                             limit: 200,
                                             allData: true),path: "Data")
            }
        }
        
    }
    
    func setupChartView() {
        chartView.delegate = self
        chartView.dataSource = self

        let colorSpace = CGColorSpaceCreateDeviceRGB()

        let topColor = AliceColor.darkGrey()
        let bottomColor = AliceColor.lightBackground()
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        let locations: [CGFloat] = [0.0, 0.7]
//
//       let topColor1 = UIColor(hex: "85D7E2", alpha: 0.1)
//       let bottomColor1 = UIColor(hex: "FFFFFF", alpha: 1.0)
//       let gradientColors1 : [CGColor] = [topColor1.cgColor,bottomColor1.cgColor]
//       let locations1 : [CGFloat] = [0.0, 1.0]
//
        gradient = CGGradient(colorsSpace: colorSpace, colors: gradientColors as CFArray, locations: locations)
//        self.lineGradient = CGGradient(colorsSpace: colorSpace, colors: gradientColors1 as CFArray, locations: locations1)

        chartView.gradientBottom = gradient!
//        chartView.gradientLine = self.lineGradient!
        
        chartView.enableTouchReport = true
        chartView.enablePopUpReport = true
//        chartView.enableReferenceAxisFrame = true
        
        chartView.formatStringForValues = "%.3f"
        
        // Draw an average line
        chartView.averageLine.enableAverageLine = true
        chartView.averageLine.alpha = 0.6
        chartView.averageLine.color = AliceColor.greyNew()
        chartView.averageLine.width = 2.5
        chartView.averageLine.dashPattern = [2, 2]

        chartView.noDataLabelColor = AliceColor.darkGrey()
        chartView.colorTouchInputLine = AliceColor.darkGrey()
        
//        chartView.alwaysDisplayPopUpLabels = true
//        chartView.colorBackgroundPopUplabel =
//        chartView.displayDotsWhileAnimating = false

        chartView.colorBackgroundPopUplabel = AliceColor.white()
        chartView.enableBottomReferenceAxisFrameLine = false
        
        requestData()
    }

    func numberOfPoints(inLineGraph _: BEMSimpleLineGraphView) -> Int {
        return data.count
    }

    func lineGraph(_: BEMSimpleLineGraphView, valueForPointAt index: Int) -> CGFloat {
        let info = data[index]
        return CGFloat(info.close)
    }

//     MARK: - Request DATA
    func requestData() {
//        if let list = data[coin], list.count > 0 {
//            chartView.reloadGraph()
//            return
//        }

        guard let symbol = coin.info?.symbol.lowercased() else {
            return
        }
        
        self.startGraphLoading()

        firstly { () -> Promise<CryptocompareHistoryModel> in
//            API(Cryptocompare.historyDay(symbol: symbol,
//                                         currency: PriceHelper.shared.currentCurrency,
//                                         limit: 30, allData: false), path: "Data")
            currentPeriod.requestMethod(symbol: symbol)
        }.done { model in
            if let data = model.Data {
                self.data = data
                self.chartView.reloadGraph()
            }
        }.ensure {
            self.stopGraphLoading()
        }.catch { error in
            print(error.localizedDescription)
            self.chartView.reloadGraph()
        }
    }
    
    func lineGraph(_ graph: BEMSimpleLineGraphView, didTouchGraphWithClosestIndex index: Int) {
        
        let model = self.data[index]
        openLabel.text = String(model.open)
        HighLabel.text = String(model.high)
        lowLabel.text = String(model.low)
        volFromLabel.text = String(model.volumefrom)
        volToLabel.text = String(model.volumeto)
        closeLabel.text = String(model.close!)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = currentPeriod == .oneDay ? "d MMMM HH:mm" : "dd MMM yyyy"
        let date = Date(timeIntervalSince1970: model.time)
        timeLabel.text = dateFormatter.string(from: date)
    }
    
    func lineGraph(_ graph: BEMSimpleLineGraphView, didReleaseTouchFromGraphWithClosestIndex index: CGFloat) {
        
        guard let info = coin.info, let market = info.market else {
            return
        }
        
        openLabel.text = String(market.open24H)
        HighLabel.text = String(market.high24H)
        lowLabel.text = String(market.low24H)
        closeLabel.text = String(info.price!)
        
        mktcapLabel.text = String(market.MKTCAP.doubleValue)
        supplyLabel.text = String(market.supply)
        volFromLabel.text = String(market.vol24H)
        volToLabel.text = String(market.volTo24H)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy 'at' HH:mm"
        let date = Date(timeIntervalSince1970: market.lastUpdate)
        timeLabel.text = dateFormatter.string(from: date)
    }
    
//    func popUpSuffixForlineGraph(_ graph: BEMSimpleLineGraphView) -> String {
//
//    }
    
//    func popUpPrefixForlineGraph(_ graph: BEMSimpleLineGraphView) -> String {
//        let currency = PriceHelper.shared.currentCurrency
//        return "\(currency.rawValue) \(currency.symbol)"
//    }
    
//    func lineGraphDidBeginLoading(_ graph: BEMSimpleLineGraphView) {
//
//    }
    
    func startGraphLoading() {
        loadingView.isHidden = false
        loadingView.alpha = 0.0
        self.loadingIndicator.isHidden = true
        self.loadingIndicator.startAnimating()
        UIView.animate(withDuration: 0.3) {
            self.loadingView.alpha = 1.0
            self.loadingIndicator.isHidden = false
        }
    }
    
    func stopGraphLoading() {
        loadingView.alpha = 1.0
        UIView.animate(withDuration: 0.3, animations: {
            self.loadingView.alpha = 0.0
        }) { _ in
            self.loadingIndicator.isHidden = true
            self.loadingView.isHidden = true
        }
        self.loadingIndicator.startAnimating()
    }
    
 }

extension AssetDetailHeader: BEMSimpleLineGraphDelegate {
    
}
