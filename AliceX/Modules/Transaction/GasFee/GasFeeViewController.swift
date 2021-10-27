//
//  GasFeeViewController.swift
//  AliceX
//
//  Created by lmcmz on 19/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import BigInt
import UIKit

class GasFeeViewController: BaseViewController {
    @IBOutlet var container: UIView!

    @IBOutlet var slowLabel: UILabel!
    @IBOutlet var slowEthLabel: UILabel!
    @IBOutlet var slowTimeLabel: UILabel!

    @IBOutlet var aveLabel: UILabel!
    @IBOutlet var aveEthLabel: UILabel!
    @IBOutlet var aveTimeLabel: UILabel!

    @IBOutlet var fastLabel: UILabel!
    @IBOutlet var fastEthLabel: UILabel!
    @IBOutlet var fastTimeLabel: UILabel!

    @IBOutlet var highlightCenter: NSLayoutConstraint!
    @IBOutlet var highlightView: UIView!

    var gasLimit: BigUInt!

    class func make(gasLimit: BigUInt) -> GasFeeViewController {
        let vc = GasFeeViewController()
        vc.gasLimit = gasLimit
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let eth = (gasLimit?.gweiToEth)!

        let slowEth = GasPrice.slow.toEthString(gasLimit: gasLimit)
        let aveEth = GasPrice.average.toEthString(gasLimit: gasLimit)
        let fastEth = GasPrice.fast.toEthString(gasLimit: gasLimit)

        slowEthLabel.text = "\(slowEth) ETH"
        aveEthLabel.text = "\(aveEth) ETH"
        fastEthLabel.text = "\(fastEth) ETH"

        slowTimeLabel.text = GasPrice.slow.timeString
        aveTimeLabel.text = GasPrice.average.timeString
        fastTimeLabel.text = GasPrice.fast.timeString

        let currency = PriceHelper.shared.currentCurrency
        let prefix = "\(currency.rawValue) \(currency.symbol)"

        let slowPrice = GasPrice.slow.toCurrencyString(gasLimit: gasLimit)
        let avePrice = GasPrice.average.toCurrencyString(gasLimit: gasLimit)
        let fastPrice = GasPrice.fast.toCurrencyString(gasLimit: gasLimit)

        slowLabel.text = "\(prefix) \(slowPrice)"
        aveLabel.text = "\(prefix) \(avePrice)"
        fastLabel.text = "\(prefix) \(fastPrice)"
    }

    override func viewDidLayoutSubviews() {
        //        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
        container.roundCorners(corners: [.topLeft, .topRight], radius: 10)
    }

    @IBAction func fastBtnClicked() {
        postNotification(gasPrice: .fast)
        dismiss()
    }

    @IBAction func aveBtnClicked() {
        postNotification(gasPrice: .average)
        dismiss()
    }

    @IBAction func slowBtnClicked() {
        postNotification(gasPrice: .slow)
        dismiss()
    }

    @IBAction func dismiss() {
        HUDManager.shared.dismiss()
    }

    func postNotification(gasPrice: GasPrice) {
        let userInfo = ["gasPrice": gasPrice.option]
        NotificationCenter.default.post(name: .gasSelectionCahnge, object: nil, userInfo: userInfo)
    }
}
