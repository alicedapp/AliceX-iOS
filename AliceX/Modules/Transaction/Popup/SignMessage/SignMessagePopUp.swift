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

    var payView: PayButtonView?

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

        payView = PayButtonView.instanceFromNib(title: "Hold To Sign")
        payButton.addSubview(payView!)
        payView!.fillSuperview()
        payView?.delegate = self
    }
}

extension SignMessagePopUp: PayButtonDelegate {
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
            let data = Data.fromHex(message)
            let signData = try TransactionManager.signMessage(message: data!)!
            print(signData)
            successBlock!(signData)
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
