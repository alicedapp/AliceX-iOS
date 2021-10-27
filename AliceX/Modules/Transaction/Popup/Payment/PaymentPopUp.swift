//
//  PaymentPopUp.swift
//  AliceX
//
//  Created by lmcmz on 19/6/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import BigInt
import PromiseKit
import SPStorkController
import UIKit
import web3swift

// Can't be BaseVIewController
class PaymentPopUp: UIViewController {
    @IBOutlet var payButton: UIControl!

    @IBOutlet var symbolLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var coinImageView: UIImageView!

    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!

    @IBOutlet var gasPriceLabel: UILabel!
    @IBOutlet var gasTimeLabel: UILabel!

    @IBOutlet var gasBtn: UIControl!

    var isCustomGasLimit: Bool = false

    var toAddress: String?
    var amount: BigUInt!
    var data: Data!
    var successBlock: StringBlock?

    var gasLimit: BigUInt!
    var gasPrice: GasPrice = GasPrice.average

    var coin: Coin!
    var payView: PayButtonView?

    class func make(toAddress: String,
                    amount: BigUInt,
                    data: Data,
                    coin: Coin,
                    gasPrice: GasPrice = GasPrice.average,
                    gasLimit: BigUInt = BigUInt(0),
                    success: @escaping StringBlock) -> PaymentPopUp {
        let vc = PaymentPopUp()
        vc.toAddress = toAddress
        vc.amount = amount
        vc.successBlock = success
        vc.data = data
        vc.coin = coin
        vc.gasLimit = gasLimit
        vc.gasPrice = gasPrice
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        isCustomGasLimit = gasLimit != BigUInt(0)

        let chain = coin.blockchain
        guard let info = coin.info else {
            HUDManager.shared.showError(text: "Wrong coin type")
            dismiss(animated: true, completion: nil)
            return
        }

        coinImageView.kf.setImage(with: coin.image)

        symbolLabel.text = info.symbol
        nameLabel.text = "\(info.name!) Coin"

        addressLabel.text = toAddress

        let amountStr = amount.formatToPrecision(decimals: info.decimals)!
        amountLabel.text = amountStr

        if let price = info.price {
            let finalPrice = price * Double(amountStr)!
            priceLabel.text = finalPrice.currencyString
        }

        payView = PayButtonView.instanceFromNib(colorChange: coin == Coin.coin(chain: .Ethereum))
        payButton.addSubview(payView!)
        payView!.fillSuperview()
        payView?.delegate = self

        if chain != .Ethereum {
            gasBtn.isHidden = true
            return
        }

        /// If not Ethereum, not support change gas price

        gasTimeLabel.text = "Arrive in ~ \(gasPrice.time) mins"

        gasBtn.isUserInteractionEnabled = false
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(gasChange(_:)),
                                               name: .gasSelectionCahnge, object: nil)

        firstly {
            GasPriceHelper.shared.getGasPrice()
        }.then {
            TransactionManager.shared.gasForSendingEth(to: self.toAddress!, amount: self.amount!, data: self.data)
        }.done { gasLimit in

            if !self.isCustomGasLimit { // NO Custom Gas Limit
                self.gasLimit = gasLimit
            }

            self.gasPriceLabel.text = self.gasPrice.toCurrencyFullString(gasLimit: gasLimit)
            self.gasBtn.isUserInteractionEnabled = true
            self.gasTimeLabel.text = "Arrive in ~ \(self.gasPrice.time) mins"
        }.catch { _ in
            self.gasPriceLabel.text = "Failed to get gas"
            self.gasPriceLabel.textColor = UIColor(hex: "FF7E79")
        }
    }

    // MARK: - GAS Notification

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @IBAction func gasButtonClick() {
        let vc = GasFeeViewController.make(gasLimit: gasLimit!)
        HUDManager.shared.showAlertVCNoBackground(viewController: vc)
    }

    @objc func gasChange(_ notification: Notification) {
        guard let text = notification.userInfo?["gasPrice"] as? String,
              let gasPrice = GasPrice.make(string: text) else { return }

        self.gasPrice = gasPrice
        updateGas()
    }

    func updateGas() {
        gasTimeLabel.text = "Arrive in ~ \(gasPrice.time) mins"
        gasPriceLabel.text = gasPrice.toCurrencyFullString(gasLimit: gasLimit!)
    }
}

extension PaymentPopUp: PayButtonDelegate {
    // MARK: - Verify

    func verifyAndSend() {
        #if DEBUG
        send()
        #else
        biometricsVerify()
        #endif
    }

    func biometricsVerify() {
        firstly {
            FaceIDHelper.shared.faceID()
        }.done { _ in
            self.send()
        }
    }

    func send() {
        payView!.showLoading()

        let chain = coin.blockchain
        //        guard  else {
        //            return
        //        }

        var gasLimitOption = TransactionOptions.GasLimitPolicy.automatic
        if isCustomGasLimit {
            gasLimitOption = TransactionOptions.GasLimitPolicy.manual(gasLimit)
        }

        firstly {
            chain.transfer(toAddress: toAddress!, value: amount!, data: self.data,
                           gasPrice: gasPrice, gasLimit: gasLimitOption)
        }.done { hash in
            print(hash)
            self.successBlock!(hash)
            self.dismiss(animated: true, completion: nil)
        }.catch { error in
            self.payView!.failed()
            HUDManager.shared.showError(error: error)
        }

        //        firstly {
        //            TransactionManager.shared.sendEtherSync(
        //                to: toAddress!,
        //                amount: amount!,
        //                data: data!,
        //                password: "",
        //                gasPrice: gasPrice
        //            )
        //        }.done { hash in
        //            print(hash)
        //            self.successBlock!(hash)
        //            self.dismiss(animated: true, completion: nil)
        //        }.catch { error in
        //            self.payView!.failed()
        //            HUDManager.shared.showError(error: error)
        //        }
    }
}
