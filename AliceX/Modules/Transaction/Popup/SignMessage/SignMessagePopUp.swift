//
//  SignMessagePopUp.swift
//  AliceX
//
//  Created by lmcmz on 27/6/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import PromiseKit
import UIKit

class SignMessagePopUp: UIViewController {
    @IBOutlet var payButton: UIControl!
    @IBOutlet var progressIndicator: RPCircularProgress!
    @IBOutlet var payButtonContainer: UIView!

    @IBOutlet var messageTextView: UITextView!

    var message: String!

    var timer: Timer?
    var process: Int = 0
    var toggle: Bool = false

    var successBlock: StringBlock?

    class func make(message: String, success: @escaping StringBlock) -> SignMessagePopUp {
        let vc = SignMessagePopUp()
        vc.message = message
        vc.successBlock = success
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let msgText = message.hexDecodeUTF8 else {
            HUDManager.shared.showError(text: "Message hex can't be decode")
            dismiss(animated: true, completion: nil)
            return
        }

        messageTextView.text = msgText

        payButtonContainer.layer.cornerRadius = 20
        payButtonContainer.layer.masksToBounds = true

//        let gradient: CAGradientLayer = CAGradientLayer()
//        gradient.colors = [UIColor(hex: "333333").cgColor, UIColor(hex: "333333").cgColor]
//        gradient.locations = [0.0, 1.0]
//        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
//        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
//        gradient.frame = payButton.bounds
//        payButtonContainer.layer.insertSublayer(gradient, at: 0)

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
                send()
            #else
                biometricsVerify()
            #endif

            toggle = true
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
    }

    @IBAction func payButtonClick() {
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
            self.payButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.progressIndicator.updateProgress(0.2, animated: true, initialDelay: 0, duration: 0.2, completion: {
                self.progressIndicator.updateProgress(0)
            })
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                self.payButton.transform = CGAffineTransform.identity
            }
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
        }.done { _ in
            self.send()
        }
    }

    func send() {
        do {
            let data = Data.fromHex(message)
            let signData = try TransactionManager.signMessage(message: data!)!
            print(signData)
            successBlock!(signData)
            dismiss(animated: true, completion: nil)
        } catch let error as WalletError {
            HUDManager.shared.showError(text: error.errorMessage)
        } catch {
            print(error)
            HUDManager.shared.showError()
        }
    }
}
