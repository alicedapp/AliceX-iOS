//
//  SignTransactionPopUp.swift
//  AliceX
//
//  Created by lmcmz on 10/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import BigInt
import PromiseKit
import UIKit

class SignTransactionPopUp: UIViewController {
    @IBOutlet var payButton: UIControl!
    @IBOutlet var progressIndicator: RPCircularProgress!
    @IBOutlet var payButtonContainer: UIView!

    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!

    @IBOutlet var priceLabel: UILabel!

    @IBOutlet var gasPriceLabel: UILabel!
    @IBOutlet var gasTimeLabel: UILabel!
    @IBOutlet var gasBtn: UIControl!

    var toAddress: String!
    var amount: BigUInt!
    var data: Data!
    var detailObject: Bool!

    var timer: Timer?
    var process: Int = 0
    var toggle: Bool = false

    var gasLimit: BigUInt?
    var gasPrice: GasPrice = GasPrice.average

    var successBlock: StringBlock?

    var payView: PayButtonView?

    class func make(toAddress: String,
                    amount: BigUInt,
                    data: Data,
                    detailObject: Bool = false,
                    success: @escaping StringBlock) -> SignTransactionPopUp {
        let vc = SignTransactionPopUp()
        vc.toAddress = toAddress
        vc.amount = amount
        vc.data = data
        vc.detailObject = detailObject
        vc.successBlock = success
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addressLabel.text = toAddress

        let value = amount.readableValue
        amountLabel.text = value.round(decimal: 4)
        let price = Float(value)! * PriceHelper.shared.exchangeRate
        priceLabel.text = price.currencyString

        payView = PayButtonView.instanceFromNib(title: "Hold To Sign")
        payButton.addSubview(payView!)
        payView!.fillSuperview()
        payView?.delegate = self

        gasBtn.isUserInteractionEnabled = false

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(gasChange(_:)),
                                               name: .gasSelectionCahnge, object: nil)

        firstly {
            GasPriceHelper.shared.getGasPrice()
        }.then {
            TransactionManager.shared.gasForSendingEth(to: self.toAddress, amount: self.amount, data: self.data)
        }.done { gasLimit in
            self.gasLimit = gasLimit
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

extension SignTransactionPopUp: PayButtonDelegate {
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
        do {
            let signJson = try TransactionManager.signTransaction(to: toAddress!,
                                                                  amount: amount!,
                                                                  data: data!,
                                                                  detailObject: detailObject)
            successBlock!(signJson)
            dismiss(animated: true, completion: nil)
        } catch let error as WalletError {
            HUDManager.shared.showError(text: error.errorMessage)
            self.payView!.failed()
        } catch {
            print(error)
            HUDManager.shared.showError()
            payView!.failed()
        }
    }
}
