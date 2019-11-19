//
//  CustomTokenViewController.swift
//  AliceX
//
//  Created by lmcmz on 18/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit
import web3swift
import Kingfisher

class CustomTokenViewController: BaseViewController {

    @IBOutlet var textfield: UITextField!
    @IBOutlet var testLabel: UILabel!
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var symbolLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var decimalsLabel: UILabel!
    
    @IBOutlet var coinImage: UIImageView!
    
    var passed: Bool = false
//    var info: TokenInfo?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textfield.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.endEditing(true)
    }

    class func make(model: Web3NetModel) -> RPCCustomViewController {
        let vc = RPCCustomViewController()
        vc.isUpdate = true
        vc.model = model
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        textfield.attributedPlaceholder = NSAttributedString(string: "Token Address", attributes: [NSAttributedString.Key.foregroundColor: UIColor(hex: "#9D9D9D")])
    }

    func testFailed() {
        animation()
        testLabel.text = "❌ Failed"
        testLabel.textColor = Color.red
        delay(3) {
            self.animation()
            self.testLabel.text = "Test"
            self.testLabel.textColor = UIColor.lightGray
        }
    }

    func testSuccess() {
        animation()
        testLabel.text = "✅ Pass"
        delay(3) {
            self.animation()
            self.testLabel.text = "Test"
            self.testLabel.textColor = UIColor.lightGray
        }
    }

    func animation() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        transition.type = CATransitionType(rawValue: "cube")
        transition.subtype = CATransitionSubtype.fromBottom
        testLabel.layer.add(transition, forKey: "country1_animation")
    }

    @IBAction func testClicked() {
        guard let textStr = textfield.text else {
            testFailed()
            passed = false
            return
        }
        
        let string = textStr.trimed()

        if string.isEmptyAfterTrim() {
            testFailed()
            passed = false
            return
        }
        
        let coin = Coin.coin(chain: .Ethereum)
        if !coin.verify(address: string) {
            testFailed()
            passed = false
            return
        }
        
        PriceHelper.shared.getTokenInfo(tokenAdress: string).done { info in
            self.updateToken(info: info)
        }.catch { _ in
            self.testFailed()
            self.passed = false
        }
    }
    
    func updateToken(info: TokenInfo) {
        
        guard let decimals = info.decimals, let address = info.address else {
            self.testFailed()
            self.passed = false
            return
        }
        
        self.nameLabel.text = info.name
        self.symbolLabel.text = info.symbol
        
        self.decimalsLabel.text = String(decimals)
        if let price = info.price {
            self.priceLabel.text = "\(price.currency!) \(price.rate!)"
        } else {
            self.priceLabel.text = "Price"
        }
        
        let coin = Coin.ERC20(address: address)
        
        coinImage.kf.setImage(with: coin.image)
        
        CoinInfoCenter.shared.pool.keys.contains(address)
        
        self.testSuccess()
        self.passed = true
    }

    @IBAction func pasteClicked() {
        guard let string = UIPasteboard.general.string else {
            return
        }
        textfield.text = string
    }

    @IBAction func addClicked() {
        testClicked()
        if !passed {
            testFailed()
            return
        }

//        guard let net = testWeb3!.provider.network else {
//            testFailed()
//            return
//        }
        
    }

    @objc func addRPCSuccess() {
        HUDManager.shared.showSuccess(text: "Custom RPC Updated")
        backButtonClicked()
    }
}
