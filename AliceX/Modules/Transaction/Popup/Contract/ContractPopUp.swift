//
//  ContractPopUp.swift
//  AliceX
//
//  Created by lmcmz on 26/6/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import BigInt
import MarqueeLabel
import PromiseKit
import UIKit
import web3swift

class ContractPopUp: UIViewController {
    @IBOutlet var payButton: UIControl!

    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var functionLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    @IBOutlet var paramterLabel: MarqueeLabel!

    @IBOutlet var priceLabel: UILabel!

    @IBOutlet var gasPriceLabel: UILabel!
    @IBOutlet var gasTimeLabel: UILabel!
    @IBOutlet var gasBtn: UIControl!

    var gasLimit: BigUInt!
    var gasPrice: GasPrice = GasPrice.average

    var isCustomGasLimit: Bool = false

    var contractAddress: String!
    var functionName: String!
    var abi: String!
    var parameters: [Any]?
    var value: BigUInt!
    var extraData: Data!
    var successBlock: StringBlock?

    var payView: PayButtonView?

    class func make(contractAddress: String,
                    functionName: String,
                    parameters: [Any],
                    extraData: Data,
                    value: BigUInt,
                    abi: String,
                    gasLimit: BigUInt = BigUInt(0),
                    success: @escaping StringBlock) -> ContractPopUp {
        let vc = ContractPopUp()
        vc.contractAddress = contractAddress
        vc.functionName = functionName
        vc.successBlock = success
        vc.parameters = parameters
        vc.extraData = extraData
        vc.value = value
        vc.abi = abi
        vc.gasLimit = gasLimit
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        isCustomGasLimit = gasLimit != BigUInt(0)

        addressLabel.text = contractAddress

        let amountStr = Web3.Utils.formatToEthereumUnits(value, toUnits: .eth, decimals: 18, decimalSeparator: ".", fallbackToScientific: false)!
        let amountInDouble = Double(amountStr)!
        let removeZero = String(format: "%g", amountInDouble)
        valueLabel.text = removeZero

        functionLabel.text = functionName

//        let price = Float(value!)! * PriceHelper.shared.exchangeRate
//        priceLabel.text = "\(PriceHelper.shared.currentCurrency.symbol) \(price.rounded(toPlaces: 3))"

        payView = PayButtonView.instanceFromNib()
        payButton.addSubview(payView!)
        payView!.fillSuperview()
        payView?.delegate = self

        paramterLabel.type = .continuous
        paramterLabel.speed = .duration(10)
        paramterLabel.fadeLength = 10.0
        paramterLabel.trailingBuffer = 30.0
        if let para = parameters, para.count > 0 {
            paramterLabel.text = parameters!.compactMap { "\($0)" }.joined(separator: ", ")
        } else {
            paramterLabel.text = "nil"
        }

        paramterLabel.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(pauseTap))
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        paramterLabel.addGestureRecognizer(tapRecognizer)

        gasBtn.isUserInteractionEnabled = false

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(gasChange(_:)),
                                               name: .gasSelectionCahnge, object: nil)

        guard let parameters = self.parameters as? [AnyObject] else {
            HUDManager.shared.showError(text: "Parameter inVaild")
            return
        }

        firstly {
            GasPriceHelper.shared.getGasPrice()
        }.then {
            TransactionManager.shared.gasForContractMethod(to: self.contractAddress,
                                                           contractABI: self.abi,
                                                           methodName: self.functionName,
                                                           methodParams: parameters,
                                                           amount: self.value,
                                                           data: self.extraData)
        }.done { gasLimit in
            if !self.isCustomGasLimit { // NO Custom Gas Limit
                self.gasLimit = gasLimit
            }

            self.gasPriceLabel.text = self.gasPrice.toCurrencyFullString(gasLimit: gasLimit)
            self.gasBtn.isUserInteractionEnabled = true
            self.gasTimeLabel.text = "Arrive in ~ \(self.gasPrice.time) mins"
        }.catch { error in
            print(error.localizedDescription)
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
        guard let text = notification.userInfo?["gasPrice"] as? String else { return }
        let gasPrice = GasPrice(rawValue: text)!
        self.gasPrice = gasPrice
        updateGas()
    }

    func updateGas() {
        gasTimeLabel.text = "Arrive in ~ \(gasPrice.time) mins"
        gasPriceLabel.text = gasPrice.toCurrencyFullString(gasLimit: gasLimit!)
    }

    @objc func pauseTap(_ recognizer: UIGestureRecognizer) {
        let continuousLabel2 = recognizer.view as! MarqueeLabel
        if recognizer.state == .ended {
            continuousLabel2.isPaused ? continuousLabel2.unpauseLabel() : continuousLabel2.pauseLabel()
        }
    }
}

extension ContractPopUp: PayButtonDelegate {
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

        var gasLimitOption = TransactionOptions.GasLimitPolicy.automatic
        if isCustomGasLimit {
            gasLimitOption = TransactionOptions.GasLimitPolicy.manual(gasLimit)
        }

        firstly {
            TransactionManager.writeSmartContract(contractAddress: contractAddress!,
                                                  functionName: functionName!,
                                                  abi: abi!,
                                                  parameters: parameters!,
                                                  extraData: extraData,
                                                  value: value!,
                                                  gasPrice: gasPrice,
                                                  gasLimit: gasLimitOption)
        }.done { hash in
            self.successBlock!(hash)
            self.dismiss(animated: true, completion: nil)
        }.catch { error in
            self.payView!.failed()
            HUDManager.shared.showError(error: error)
        }
    }
}
