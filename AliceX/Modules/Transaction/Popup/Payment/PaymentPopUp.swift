//
//  PaymentPopUp.swift
//  AliceX
//
//  Created by lmcmz on 19/6/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit
import BigInt
import PromiseKit

// Can't be BaseVIewController
class PaymentPopUp: UIViewController {

    @IBOutlet weak var payButton: UIControl!
    @IBOutlet weak var progressIndicator: RPCircularProgress!
    @IBOutlet weak var payButtonContainer: UIView!
    
    @IBOutlet weak var sliderContainer: UIView!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var gasPriceLabel: UILabel!
    @IBOutlet weak var gasTimeLabel: UILabel!
    
    @IBOutlet weak var gasBtn: UIControl!
    
    var timer: Timer?
    var process: Int = 0
    var toggle: Bool = false
    
    var toAddress: String?
    var amount: BigUInt!
    var data: Data!
    var successBlock: StringBlock?
    
    var gasLimit: BigUInt?
    
    var gasPrice: GasPrice = GasPrice.average
    
    class func make(toAddress: String,
                    amount: BigUInt,
                    data: Data,
                    symbol: String,
                    success: @escaping StringBlock) -> PaymentPopUp {
        let vc = PaymentPopUp()
        vc.toAddress = toAddress
        vc.amount = amount
        vc.successBlock = success
        vc.data = data
        return vc 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addressLabel.text = toAddress
        
        let value = amount.readableValue
        amountLabel.text = value.round(decimal: 4)
        let price = Float(value)! * PriceHelper.shared.exchangeRate
        priceLabel.text = price.currencyString
        
        payButtonContainer.layer.cornerRadius = 20
        payButtonContainer.layer.masksToBounds = true
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [UIColor(hex: "333333").cgColor, UIColor(hex: "333333").cgColor]
//            [UIColor(hex: "659BEF").cgColor, UIColor(hex: "2060CB").cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.frame = payButton.bounds
        payButtonContainer.layer.insertSublayer(gradient, at: 0)
        
        payButton.layer.masksToBounds = false
        payButton.layer.cornerRadius = 20
        payButton.layer.shadowColor = UIColor(hex: "2060CB").cgColor
        payButton.layer.shadowRadius = 10
        payButton.layer.shadowOffset = CGSize.zero
        payButton.layer.shadowOpacity = 0.3
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        longPressGesture.minimumPressDuration = 0
        payButton.addGestureRecognizer(longPressGesture)
        progressIndicator.updateProgress(0)
        
        gasTimeLabel.text = "Arrive in ~ \(self.gasPrice.time) mins"
        
        gasBtn.isUserInteractionEnabled = false
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(gasChange(_:)),
                                               name: .gasSelectionCahnge, object: nil)
        
        firstly{
            GasPriceHelper.shared.getGasPrice()
        }.then {
            TransactionManager.shared.gasForSendingEth(to: self.toAddress!, amount: self.amount!, data: self.data)
        }.done { (gasLimit) in
            self.gasLimit = gasLimit
            self.gasPriceLabel.text = self.gasPrice.toCurrencyFullString(gasLimit: gasLimit)
            self.gasBtn.isUserInteractionEnabled = true
            self.gasTimeLabel.text = "Arrive in ~ \(self.gasPrice.time) mins"
        }.catch { (_) in
            self.gasPriceLabel.text = "Failed to get gas"
            self.gasPriceLabel.textColor = UIColor(hex: "FF7E79")
        }
    }
    
    // MARK: - GAS Notification
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func gasButtonClick() {
        let vc = GasFeeViewController.make(gasLimit: self.gasLimit!)
        HUDManager.shared.showAlertVCNoBackground(viewController: vc)
    }
    
    @objc func gasChange(_ notification: Notification) {
        guard let text = notification.userInfo?["gasPrice"] as? String else { return }
        let gasPrice = GasPrice(rawValue: text)!
        self.gasPrice = gasPrice
        updateGas()
    }
    
    func updateGas() {
        gasTimeLabel.text = "Arrive in ~ \(self.gasPrice.time) mins"
        self.gasPriceLabel.text = self.gasPrice.toCurrencyFullString(gasLimit: self.gasLimit!)
    }
    
    // MARK: - Button Animation
    
    @objc func timeUpdate() {
        process += 1
        var precentage = (Double(process) / 100)
        
        progressIndicator.updateProgress(CGFloat(precentage))
        if precentage < 1 {
            return
        }
        
        if precentage >= 1 {
            precentage = 1
        }
        
        if toggle == false {
            
            #if DEBUG
            sendTx()
            #else
            biometricsVerify()
            #endif
            
            toggle = true
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
        
    }
    
    @objc func longPress(gesture: UILongPressGestureRecognizer) {
        
        switch gesture.state {
        case .began:
            UIView.animate(withDuration: 0.2) {
                self.payButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }
            
            timer = Timer(timeInterval: 0.01, target: self, selector: #selector(timeUpdate),
                          userInfo: nil, repeats: true)
            RunLoop.current.add(timer!, forMode: .default)
            timer!.fire()
            
        case .ended, .cancelled:
            UIView.animate(withDuration: 0.2) {
                self.payButton.transform = CGAffineTransform.identity
            }
            timer!.invalidate()
            progressIndicator.updateProgress(0)
            toggle = false
            process = 0
            
        default:
            break
        }
    }
    
    @IBAction func payButtonClick() {
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
            self.payButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.progressIndicator.updateProgress(0.2, animated: true, initialDelay: 0, duration: 0.2, completion: {
                self.progressIndicator.updateProgress(0)
            })
        }) { (_) in
            UIView.animate(withDuration: 0.2) {
                self.payButton.transform = CGAffineTransform.identity
            }
        }
    }
    
    // MARK: - Verify
    
    func biometricsVerify() {
        firstly {
            FaceIDHelper.shared.faceID()
        }.done { (_) in
            self.sendTx()
        }
    }
    
    func sendTx() {
        do {
            let txHash = try TransactionManager.shared.sendEtherSync(
                to: toAddress!,
                amount: amount!,
                data: data!,
                password: "",
                gasPrice: gasPrice)
            
            self.successBlock!(txHash)
            self.dismiss(animated: true, completion: nil)
        } catch let error as WalletError {
            HUDManager.shared.showError(text: error.errorMessage)
        } catch {
            HUDManager.shared.showError()
        }
    }

}
