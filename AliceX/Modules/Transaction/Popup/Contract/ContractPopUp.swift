//
//  ContractPopUp.swift
//  AliceX
//
//  Created by lmcmz on 26/6/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit
import LocalAuthentication
import MarqueeLabel

class ContractPopUp: UIViewController {

    @IBOutlet weak var payButton: UIControl!
    @IBOutlet weak var progressIndicator: RPCircularProgress!
    @IBOutlet weak var payButtonContainer: UIView!
    
//    @IBOutlet weak var sliderContainer: UIView!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var functionLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var paramterLabel: MarqueeLabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    var timer: Timer?
    var process: Int = 0
    var toggle: Bool = false
    
    var contractAddress: String?
    var functionName: String?
    var abi: String?
    var parameters: [Any]?
    var value: String?
    var extraData: String?
    var successBlock: StringBlock?
    
    class func make(contractAddress: String,
                    functionName: String,
                    parameters: [Any],
                    extraData: String,
                    value: String,
                    abi: String,
                    success: @escaping StringBlock) -> ContractPopUp {
        let vc = ContractPopUp()
        vc.contractAddress = contractAddress
        vc.functionName = functionName
        vc.successBlock = success
        vc.parameters = parameters
        vc.extraData = extraData
        vc.value = value
        vc.abi = abi
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addressLabel.text = self.contractAddress
        valueLabel.text = self.value
        functionLabel.text = self.functionName
        
//        let price = Float(value!)! * PriceHelper.shared.exchangeRate
//        priceLabel.text = "\(PriceHelper.shared.currentCurrency.symbol) \(price.rounded(toPlaces: 3))"
        
        payButtonContainer.layer.cornerRadius = 20
        payButtonContainer.layer.masksToBounds = true
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [UIColor(hex: "333333").cgColor, UIColor(hex: "333333").cgColor]
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
        
        paramterLabel.type = .continuous
        paramterLabel.speed = .duration(10)
        paramterLabel.fadeLength = 10.0
        paramterLabel.trailingBuffer = 30.0
        paramterLabel.text = (parameters as! [String]).compactMap({$0}).joined(separator: ", ")
        
        paramterLabel.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(pauseTap))
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        paramterLabel.addGestureRecognizer(tapRecognizer)
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
    
    @objc func pauseTap(_ recognizer: UIGestureRecognizer) {
        let continuousLabel2 = recognizer.view as! MarqueeLabel
        if recognizer.state == .ended {
            continuousLabel2.isPaused ? continuousLabel2.unpauseLabel() : continuousLabel2.pauseLabel()
        }
    }
    
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
    
    func biometricsVerify() {
        let myContext = LAContext()
        let myLocalizedReasonString = "Payment Verify"
        
        var authError: NSError?
        if #available(iOS 8.0, macOS 10.12.1, *) {
            if myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                myContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                         localizedReason: myLocalizedReasonString)
                { success, evaluateError in
  
                    DispatchQueue.main.async {
                        if success {
                            // User authenticated successfully, take appropriate action
                            self.sendTx()
                        } else {
                            // User did not authenticate successfully, look at error and take appropriate action
                            
                        }
                    }
                }
            } else {
                // Could not evaluate policy; look at authError and present an appropriate message to user
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func sendTx() {
        do {
            let txHash = try TransactionManager.writeSmartContract(contractAddress: contractAddress!,
                                                                   functionName: functionName!,
                                                                   abi: abi!,
                                                                   parameters: parameters!,
                                                                   extraData: value!.data(using: .utf8)!,
                                                                   value: value!)
            print(txHash)
            self.successBlock!(txHash)
            self.dismiss(animated: true, completion: nil)
        } catch let error as WalletError {
            HUDManager.shared.showError(text: error.errorMessage)
        } catch {
            print(error)
            HUDManager.shared.showError()
        }
    }
}
