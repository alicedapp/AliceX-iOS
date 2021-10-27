//
//  CustomTokenViewController.swift
//  AliceX
//
//  Created by lmcmz on 18/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Kingfisher
import UIKit
import web3swift

class CustomTokenViewController: BaseViewController {
    @IBOutlet var textfield: UITextField!
    @IBOutlet var testLabel: UILabel!

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var symbolLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var decimalsLabel: UILabel!

    @IBOutlet var coinImage: UIImageView!

    var passed: Bool = false
    var info: TokenInfo?

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

    @IBAction func testClick() {
        testClicked(block: nil)
    }

    func testClicked(block: VoidBlock) {
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
            self.info = info
            self.updateToken(info: info)

            if let block = block {
                block()
            }

        }.catch { _ in
            self.testFailed()
            self.passed = false
        }
    }

    func updateToken(info: TokenInfo) {
        guard let decimals = info.decimals, let address = info.address else {
            testFailed()
            passed = false
            return
        }

        nameLabel.text = info.name
        symbolLabel.text = info.symbol

        decimalsLabel.text = String(decimals)
        if let price = info.price {
            priceLabel.text = "\(price.currency!) \(price.rate!)"
        } else {
            priceLabel.text = "Price"
        }

        let coin = Coin.ERC20(address: address)

        coinImage.kf.setImage(with: coin.image) { response in
            switch response {
            case .success:
                self.coinImage.backgroundColor = .clear
            default:
                break
            }
        }

        //        CoinInfoCenter.shared.pool.keys.contains(address)
        testSuccess()
        passed = true
    }

    @IBAction func pasteClicked() {
        guard let string = UIPasteboard.general.string else {
            return
        }
        textfield.text = string
    }

    @IBAction func addClicked() {
        testClicked {
            guard let address = self.textfield.text, let info = self.info else {
                self.testFailed()
                return
            }

            var data = CoinInfo(id: address)
            data.name = info.name
            data.symbol = info.symbol
            data.decimals = info.decimals

            CoinInfoCenter.shared.add(info: data)
            CoinInfoCenter.shared.storeInCache()
            WatchingCoinHelper.shared.add(coin: .ERC20(address: address), updateCache: true, checkIgnore: true)
            HUDManager.shared.showSuccess(text: "Added new coin")
            self.navigationController?.popViewController(animated: true)
        }
        if !passed {
            testFailed()
            return
        }
    }

    @objc func addRPCSuccess() {
        HUDManager.shared.showSuccess(text: "Custom RPC Updated")
        backButtonClicked()
    }
}
