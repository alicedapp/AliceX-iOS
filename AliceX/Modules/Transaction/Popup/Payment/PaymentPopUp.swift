//
//  PaymentPopUp.swift
//  AliceX
//
//  Created by lmcmz on 19/6/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit
import LocalAuthentication
import fluid_slider

class PaymentPopUp: UIViewController {

    @IBOutlet weak var payButton: UIControl!
    @IBOutlet weak var progressIndicator: RPCircularProgress!
    @IBOutlet weak var payButtonContainer: UIView!
    
    @IBOutlet weak var sliderContainer: UIView!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    
    var timer: Timer?
    var process: Int = 0
    var toggle: Bool = false
    
    var toAddress: String?
    var amount: String?
    var successBlock: StringBlock?
    
    var slider: Slider = Slider()
    
    class func make(toAddress: String,
                    amount: String,
                    symbol: String,
                    success: @escaping StringBlock) -> PaymentPopUp {
        let vc = PaymentPopUp()
        vc.toAddress = toAddress
        vc.amount = amount
        vc.successBlock = success
        return vc 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        payButtonContainer.layer.cornerRadius = 10
        payButtonContainer.layer.masksToBounds = true
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [UIColor(hex: "659BEF").cgColor, UIColor(hex: "2060CB").cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.frame = payButton.bounds
        payButtonContainer.layer.insertSublayer(gradient, at: 0)
        
        payButton.layer.masksToBounds = false
        payButton.layer.cornerRadius = 8
        payButton.layer.shadowColor = UIColor(hex: "2060CB").cgColor
        payButton.layer.shadowRadius = 10
        payButton.layer.shadowOffset = CGSize.zero
        payButton.layer.shadowOpacity = 0.3
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        longPressGesture.minimumPressDuration = 0
        payButton.addGestureRecognizer(longPressGesture)
        progressIndicator.updateProgress(0)
        
//        let labelTextAttributes: [NSAttributedString.Key: Any] =
//            [.font: UIFont.systemFont(ofSize: 20, weight: .bold), .foregroundColor: UIColor.white]
//        slider.attributedTextForFraction = { fraction in
//            let formatter = NumberFormatter()
//            formatter.maximumIntegerDigits = 3
//            formatter.maximumFractionDigits = 0
//            let string = formatter.string(from: (fraction * 500) as NSNumber) ?? ""
//            return NSAttributedString(string: string)
//        }
//        slider.setMinimumLabelAttributedText(NSAttributedString(string: "0", attributes: labelTextAttributes))
//        slider.setMaximumLabelAttributedText(NSAttributedString(string: "500", attributes: labelTextAttributes))
//        slider.fraction = 0.5
//        slider.shadowOffset = CGSize.zero
//        slider.shadowBlur = 5
//        slider.shadowColor = UIColor(hex: "2060CB")
//        slider.contentViewColor = UIColor(hex: "2060CB")
////        let gradientSec = CAGradientLayer()
////        gradientSec.contents = gradient.contents
////        gradientSec.frame = gradient.frame
//        slider.layer.insertSublayer(gradient, at: 0)
//        slider.valueViewColor = .white
//        slider.frame = sliderContainer.bounds
//        sliderContainer.addSubview(slider)
//
//        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
    }
    
    @objc func sliderValueChanged() {
//        self.slider.contentViewColor = UIColor(hex: "FF0000")
//        self.slider.fraction
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
            biometricsVerify()
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
    
    @IBAction func gasButtonClick() {
        
        if sliderContainer.isHidden {
            self.sliderContainer.alpha = 0
            self.sliderContainer.transform = CGAffineTransform(translationX: 0, y: 30)
            UIView.animate(withDuration: 0.3) {
                self.sliderContainer.isHidden = false
                self.sliderContainer.alpha = 1
                self.sliderContainer.transform = CGAffineTransform.identity
            }
            return
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
            self.sliderContainer.alpha = 0
            self.sliderContainer.transform = CGAffineTransform(translationX: 0, y: 30)
        }) { (_) in
            self.sliderContainer.isHidden = true
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
                            let txHash = try! TransactionManager.shared.sendEtherSync(
                                to: self.toAddress!, amount: self.amount!, password: "")
                            print(txHash)
                            self.successBlock!(txHash)
                            self.dismiss(animated: true, completion: nil)
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

}
