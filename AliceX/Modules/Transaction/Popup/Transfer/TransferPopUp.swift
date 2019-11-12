//
//  TransferPopUp.swift
//  AliceX
//
//  Created by lmcmz on 25/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import BigInt
import UIKit
import web3swift

class TransferPopUp: UIViewController {
    @IBOutlet var addressField: UITextField!
    @IBOutlet var valueField: UITextField!

    @IBOutlet var balanceTextLabel: UILabel!
    @IBOutlet var balanceLabel: UILabel!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var priceTextLabel: UILabel!
    
    @IBOutlet var symbolLabel: UILabel!
    @IBOutlet var symbolImageView: UIImageView!

    @IBOutlet var containView: UIView!
    @IBOutlet var bgView: UIView!

    var address: String?
    var value: BigUInt!
    var coin: Coin = Coin.coin(chain: .Ethereum)
    
    var amount: BigUInt! = BigUInt(0)
    
    class func make(address: String?, value: BigUInt! = BigUInt(0), coin: Coin = .coin(chain: .Ethereum)) -> TransferPopUp {
        let vc = TransferPopUp()
        vc.value = value
        vc.address = address
        vc.coin = coin
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addressField.text = address
        valueField.text = value.readableValue
        
//        symbolLabel.text = coin.
        symbolLabel.text = coin.info!.symbol
        symbolImageView.kf.setImage(with: coin.image)
        
        valueFieldDidChange(valueField)
        
        if let info = coin.info, let amountStr = info.amount,
            let bigAmount = BigUInt(amountStr), let amount = Web3.Utils.formatToPrecision(bigAmount, numberDecimals: info.decimals, formattingDecimals: 3, decimalSeparator: ".", fallbackToScientific: true) {
            balanceLabel.text = amount
        } else {
            balanceLabel.text = "0.0"
        }
        
    }

    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)

        containView.transform = CGAffineTransform(translationX: 0, y: -400)
        bgView.alpha = 0

        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: {
                           self.bgView.alpha = 1
                           self.containView.transform = CGAffineTransform.identity
                       }, completion: { _ in
                           if self.address != nil {
                               self.valueField.becomeFirstResponder()
                               return
                           }
                           self.addressField.becomeFirstResponder()
        })
    }

//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        UIView.animate(withDuration: 0.3,
//                       delay: 0,
//                       usingSpringWithDamping: 0.9,
//                       initialSpringVelocity: 0,
//                       options: [],
//                       animations: {
//            self.bgView.alpha = 0
//            self.containView.transform = CGAffineTransform(translationX: 0, y: -400)
//        }, completion: nil)
//    }

    @IBAction func cancelBtnClicked() {
        view.endEditing(true)
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: {
                           self.bgView.alpha = 0
                           self.containView.transform = CGAffineTransform(translationX: 0, y: -400)
                       }, completion: { _ in
                           self.dismiss(animated: false, completion: nil)
        })
    }

    @IBAction func maxBtnClicked() {
        if let info = coin.info, let amountStr = info.amount,
            let bigAmount = BigUInt(amountStr),
            let amount = Web3.Utils.formatToPrecision(bigAmount, numberDecimals: info.decimals, formattingDecimals: 3, decimalSeparator: ".", fallbackToScientific: true) {
            valueField.text = amount
            self.amount = bigAmount
        } else {
            balanceLabel.text = "0.0"
        }
    }
    
    @IBAction func pasteBtnClicked() {
        let address = UIPasteboard.general.string
        guard let ethAddress = address?.ethAddress else {
            return
        }
        addressField.text = ethAddress.address
    }

    @IBAction func cameraBtnClicked() {
        let vc = QRCodeReaderViewController.make { hash in
            guard let address = EthereumAddress(hash) else {
                self.errorAlert(text: "Addess invalid")
                return
            }
            self.addressField.text? = hash
        }
        present(vc, animated: true, completion: nil)
    }

    @IBAction func confirmBtnClicked() {
        guard let ethAddress = addressField.text?.ethAddress else {
            errorAlert(text: "Addess invalid")
            return
        }
        
        // TODO
//        guard let amount = Web3Utils.parseToBigUInt(valueField.text!, decimals: decimals) else {
//            errorAlert(text: "Value invalid")
//            return
//        }

        if self.amount <= 0 {
            errorAlert(text: "Can't be zero")
            return
        }

        if coin.type == "ERC20" {
            TransactionManager.showTokenView(token: coin,
                                             toAddress: ethAddress.address,
                                             amount: amount, data: Data()) { _ in
                                                self.cancelBtnClicked()
            }
        } else {
            TransactionManager.showPaymentView(toAddress: ethAddress.address,
                                               amount: self.amount,
                                               data: Data(),
                                               symbol: "ETH") { _ in
                self.cancelBtnClicked()
            }
        }
    }

    @IBAction func valueFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text, let amount = Double(text) else {
            return
        }
        
        guard let info = coin.info, let price = info.price else {
            priceLabel.text = "price"
            return
        }
        
        let finalPrice = amount * price
        priceLabel.text = finalPrice.currencyString
        
        guard let decimals = info.decimals else {
            errorAlert(text: "Decimals invalid")
            return
        }
        
        guard let amountBigInt = Web3Utils.parseToBigUInt(valueField.text!, decimals: decimals) else {
            errorAlert(text: "Value invalid")
            return
        }
        
        self.amount = amountBigInt
    }

    // MARK: Error

    func errorAlert(text: String) {
        errorAnimation()
        titleLabel.text = text
        titleLabel.textColor = Color.red
        delay(3) {
            self.errorAnimation()
            self.titleLabel.text = "🤑 Transfer"
            self.titleLabel.textColor = UIColor.lightGray
        }
    }

    func errorAnimation() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        transition.type = CATransitionType(rawValue: "cube")
        transition.subtype = CATransitionSubtype.fromBottom
        titleLabel.layer.add(transition, forKey: "country1_animation")
//        transition.subtype = CATransitionSubtype.fromTop
//        country2.layer.add(transition, forKey: "country2_animation")
    }
}
