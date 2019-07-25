//
//  RNCustomPopUp.swift
//  Alice
//
//  Created by lmcmz on 5/6/19.
//

import UIKit
import PromiseKit
import BigInt

class RNCustomPopUp: UIViewController {
    
    @IBOutlet weak var payButton: UIControl!
    @IBOutlet weak var progressIndicator: RPCircularProgress!
    @IBOutlet weak var payButtonContainer: UIView!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var RNContainer: UIView!
    @IBOutlet weak var RNContainerHeight: NSLayoutConstraint!
    
    var timer: Timer?
    var process: Int = 0
    var toggle: Bool = false

    var toAddress: String!
    var amount: BigUInt!
    var data: Data!
    var successBlock: StringBlock?
    
    var height: CGFloat = 500
    
    let footerHeight: CGFloat = 80+60+20
    let headerHeight: CGFloat = 10+60+20
    
    class func make(toAddress: String, amount: BigUInt, height: CGFloat, data: Data,
                                  successBlock: @escaping StringBlock) -> RNCustomPopUp {
        let vc = RNCustomPopUp()
        vc.toAddress = toAddress
        vc.amount = amount
        vc.successBlock = successBlock
        vc.height = height
        vc.data = data
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RNContainerHeight.constant = height - footerHeight - headerHeight - 40
        self.view.layoutIfNeeded()
        
        addressLabel.text = toAddress
        amountLabel.text = "Amount: " + "\(amount!)"
        
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
        
//        progressView.addSubview(progressIndicator)
        
        progressIndicator.updateProgress(0)
        
        
//        let rnView = RNModule.makeView(module: .embeddedView)
//        rnView!.frame = RNContainer.bounds
//        RNContainer.addSubview(rnView!)
        
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
        let rnView = RNModule.makeView(module: .embeddedView)
        rnView!.frame = RNContainer.bounds
        RNContainer.addSubview(rnView!)
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
    
    func biometricsVerify() {
        firstly {
            FaceIDHelper.shared.faceID()
        }.done { (_) in
                self.send()
        }
    }
    
    func send() {
        
        let txHash = try! TransactionManager.shared.sendEtherSync(
            to: self.toAddress!, amount: self.amount!, data: self.data!, password: "")
        print(txHash)
        self.successBlock!(txHash)
        self.dismiss(animated: true, completion: nil)
    }
}
