
//  AssetDetailHeader+Chart.swift
//  AliceX

//  Created by lmcmz on 10/2/20.
//  Copyright © 2020 lmcmz. All rights reserved.


import Foundation
import PromiseKit

 extension AssetDetailHeader: BEMSimpleLineGraphDataSource {
    
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
        
        chartView.enableReferenceYAxisLines = true
        chartView.enableReferenceXAxisLines = true
        chartView.enableTouchReport = true
        chartView.enablePopUpReport = true
        chartView.enableReferenceAxisFrame = true
        chartView.formatStringForValues = "%.3f"
        
        // Draw an average line
        chartView.averageLine.enableAverageLine = true
        chartView.averageLine.alpha = 0.6
        chartView.averageLine.color = AliceColor.greyNew()
        chartView.averageLine.width = 2.5
        chartView.averageLine.dashPattern = [2, 2]

        chartView.colorTouchInputLine = AliceColor.darkGrey()

        chartView.enableXAxisLabel = false
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

        firstly { () -> Promise<CryptocompareHistoryModel> in
            API(Cryptocompare.historyDay(symbol: symbol,
                                         currency: PriceHelper.shared.currentCurrency,
                                         limit: 30, allData: false), path: "Data")
        }.done { model in
            if let data = model.Data {
                self.data = data
                self.chartView.reloadGraph()
            }
        }.catch { error in
            print(error.localizedDescription)
            self.chartView.reloadGraph()
        }
    }
 }

 extension AssetDetailHeader: BEMSimpleLineGraphDelegate {}
