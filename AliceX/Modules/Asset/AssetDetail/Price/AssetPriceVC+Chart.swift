//
//  AssetPriceVC+Chart.swift
//  AliceX
//
//  Created by lmcmz on 6/2/20.
//  Copyright © 2020 lmcmz. All rights reserved.
//

import Foundation
import PromiseKit

extension AssetPriceViewController: BEMSimpleLineGraphDataSource {
    
    func setupChartView() {
        chartView.delegate = self
        chartView.dataSource = self

        let colorSpace = CGColorSpaceCreateDeviceRGB()

        let topColor = AliceColor.darkGrey()
        let bottomColor = AliceColor.lightBackground()
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        let locations: [CGFloat] = [0.0, 1.0]

//       let topColor1 = UIColor(hex: "85D7E2", alpha: 0.1)
//       let bottomColor1 = UIColor(hex: "FFFFFF", alpha: 1.0)
//       let gradientColors1 : [CGColor] = [topColor1.cgColor,bottomColor1.cgColor]
//       let locations1 : [CGFloat] = [0.0, 1.0]

        gradient = CGGradient(colorsSpace: colorSpace, colors: gradientColors as CFArray, locations: locations)
//        self.lineGradient = CGGradient(colorsSpace: colorSpace, colors: gradientColors1 as CFArray, locations: locations1)

        chartView.gradientBottom = gradient!
//        chartView.gradientLine = self.lineGradient!

        chartView.enableTouchReport = true
        chartView.enablePopUpReport = true
        chartView.formatStringForValues = "%.3f"

        chartView.colorTouchInputLine = UIColor(hex: "FFDD77")

        chartView.enableXAxisLabel = false
        chartView.enableBottomReferenceAxisFrameLine = false
    }

    func numberOfPoints(inLineGraph _: BEMSimpleLineGraphView) -> Int {
        if data.keys.contains(currentCoin), let list = data[currentCoin] {
            return list.count
        }
        return 0
    }

    func lineGraph(_: BEMSimpleLineGraphView, valueForPointAt index: Int) -> CGFloat {
        if data.keys.contains(currentCoin), let list = data[currentCoin],
            let model = list[index],
            let price = model.price {
            return CGFloat(price)
        }

        return 0
    }

    // MARK: - Request DATA

    func requestData() {
        let coin = currentCoin

        if data.keys.contains(coin), let list = data[coin], list.count > 0 {
            chartView.reloadGraph()
            return
        }

        guard let symbol = coin.info?.symbol.lowercased() else {
            return
        }

        firstly { () -> Promise<[AmberdataPricePoint?]> in
            API(AmberData.assetPriceHistorical(symbol: symbol), path: "payload.\(symbol)_usd")
        }.done { list in

            print("AAAAAA")
            print(list)
            self.data[coin] = list
            self.chartView.reloadGraph()

        }.catch { error in
            print("BBBB")
            print(error.localizedDescription)

            self.chartView.reloadGraph()
        }
    }
}

extension AssetPriceViewController: BEMSimpleLineGraphDelegate {
    
}
