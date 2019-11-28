//
//  SendERC20PopUp.swift
//  AliceX
//
//  Created by lmcmz on 22/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import BigInt
import Kingfisher
import PromiseKit
import UIKit
import web3swift

class SendERC20PopUp: UIViewController {
    @IBOutlet var payButton: UIControl!

    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!

    @IBOutlet var symbolLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var descLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var tokenImage: UIImageView!

    @IBOutlet var gasPriceLabel: UILabel!
    @IBOutlet var gasTimeLabel: UILabel!
    @IBOutlet var gasBtn: UIControl!

    var tokenAdress: String!
    var toAddress: String!
    var amount: BigUInt!
    var data: Data!

    var gasLimit: BigUInt?
    var gasPrice: GasPrice = GasPrice.average
    var successBlock: StringBlock!
    var tokenInfo: TokenInfo?
    var payView: PayButtonView?

    var token: Coin?

    class func make(token: Coin,
                    toAddress: String,
                    amount: BigUInt,
                    data: Data,
                    success: @escaping StringBlock) -> SendERC20PopUp {
        let vc = SendERC20PopUp()
        vc.token = token
        vc.toAddress = toAddress
        vc.amount = amount
        vc.data = data
        vc.successBlock = success
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addressLabel.text = toAddress

        let value = amount.readableValue
        amountLabel.text = value.round(decimal: 4)
//        let price = Float(value)! * PriceHelper.shared.exchangeRate
//        priceLabel.text = price.currencyString

        payView = PayButtonView.instanceFromNib()
        payButton.addSubview(payView!)
        payView!.fillSuperview()
        payView?.delegate = self

        gasBtn.isUserInteractionEnabled = false

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(gasChange(_:)),
                                               name: .gasSelectionCahnge, object: nil)

        if let info = token?.info {
            nameLabel.text = info.name
            symbolLabel.text = info.symbol
            descLabel.text = info.symbol
            tokenImage.kf.setImage(with: info.coin.image)

            if let price = info.price {
                let rate = price * Double(amount.readableValue)!
                priceLabel.text = rate.currencyString
            } else {
                priceLabel.text = ""
            }

        } else {
            firstly {
                PriceHelper.shared.getTokenInfo(tokenAdress: self.tokenAdress)
            }.done { model in
                self.tokenInfo = model
                self.updateToken()
            }.catch { error in
                print(error.localizedDescription)
                self.priceLabel.text = "Failed to get price"
                self.priceLabel.textColor = UIColor(hex: "FF7E79")
            }
        }

        firstly {
            GasPriceHelper.shared.getGasPrice()
        }.then {
            TransactionManager.shared.gasForContractMethod(to: self.toAddress,
                                                           contractABI: Web3.Utils.erc20ABI,
                                                           methodName: "transfer",
                                                           methodParams: [self.toAddress.ethAddress!, self.amount] as [AnyObject],
                                                           amount: self.amount,
                                                           data: self.data)
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

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func updateToken() {
        guard let info = self.tokenInfo else {
            return
        }

        nameLabel.text = info.symbol
        symbolLabel.text = info.symbol
        descLabel.text = info.name
        tokenImage.kf.setImage(with: URL(string: info.image!))
        let rate = (info.price!.rate * Double(amount.readableValue)!).rounded(toPlaces: 4)
        priceLabel.text = "\(info.price!.currency!) \(rate)"
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

extension SendERC20PopUp: PayButtonDelegate {
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
        guard let value = Web3Utils.parseToBigUInt(amount.readableValue, units: .eth) else {
            HUDManager.shared.showError(text: "Value is invalid")
            return
        }

        payView!.showLoading()

        firstly {
            TransactionManager.shared.sendERC20Token(tokenAddrss: tokenAdress,
                                                     to: toAddress,
                                                     amount: value,
                                                     data: data,
                                                     password: "",
                                                     gasPrice: gasPrice)
        }.done { hash in
            print(hash)
            self.successBlock!(hash)
            self.dismiss(animated: true, completion: nil)
        }.catch { error in
            self.payView!.failed()
            HUDManager.shared.showError(error: error)
        }
    }
}
