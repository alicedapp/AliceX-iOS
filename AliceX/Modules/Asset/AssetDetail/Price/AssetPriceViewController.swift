//
//  AssetPriceViewController.swift
//  AliceX
//
//  Created by lmcmz on 6/2/20.
//  Copyright © 2020 lmcmz. All rights reserved.
//

import UIKit

class AssetPriceViewController: UIViewController {
    @IBOutlet var scrollView: UIScrollView!
    var listViewDidScrollCallback: ((UIScrollView) -> Void)?

    @IBOutlet var chartView: BEMSimpleLineGraphView!

    var gradient: CGGradient?
    var data = [Coin: [AmberdataPricePoint?]]()

    var currentCoin: Coin = .coin(chain: .Ethereum)

    override func viewDidLoad() {
        super.viewDidLoad()

//        chartView = BEMSimpleLineGraphView()
    }
}

extension AssetPriceViewController: JXPagingViewListViewDelegate {
    public override func listView() -> UIView {
        return view
    }

    public func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> Void) {
        listViewDidScrollCallback = callback
    }

    public func listScrollView() -> UIScrollView {
        return scrollView
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        listViewDidScrollCallback?(scrollView)
    }
}
