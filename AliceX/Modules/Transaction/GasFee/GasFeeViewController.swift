//
//  GasFeeViewController.swift
//  AliceX
//
//  Created by lmcmz on 19/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit
import BigInt

class GasFeeViewController: BaseViewController {

    @IBOutlet weak var container: UIView!
    
    @IBOutlet weak var slowLabel: UILabel!
    @IBOutlet weak var slowEthLabel: UILabel!
    @IBOutlet weak var slowTimeLabel: UILabel!
    
    @IBOutlet weak var aveLabel: UILabel!
    @IBOutlet weak var aveEthLabel: UILabel!
    @IBOutlet weak var aveTimeLabel: UILabel!
    
    @IBOutlet weak var fastLabel: UILabel!
    @IBOutlet weak var fastEthLabel: UILabel!
    @IBOutlet weak var fastTimeLabel: UILabel!
    
    @IBOutlet weak var highlightCenter: NSLayoutConstraint!
    @IBOutlet weak var highlightView: UIView!
    
    
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
        self.view.layoutIfNeeded()
        self.container.roundCorners(corners: [.topLeft, .topRight], radius: 10)
    }
    
    @IBAction func fastBtnClicked() {
        postNotification(gasPrice: .fast)
        self.dismiss()
    }
    
    @IBAction func aveBtnClicked() {
        postNotification(gasPrice: .average)
        self.dismiss()
    }
    
    @IBAction func slowBtnClicked() {
        postNotification(gasPrice: .slow)
        self.dismiss()
    }
    
    @IBAction func dismiss() {
        HUDManager.shared.dismiss()
    }
    
    func postNotification(gasPrice: GasPrice) {
        let userInfo = [ "gasPrice": gasPrice.rawValue]
        NotificationCenter.default.post(name: .gasSelectionCahnge, object: nil, userInfo: userInfo)
    }
}
