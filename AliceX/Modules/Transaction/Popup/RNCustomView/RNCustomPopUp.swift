//
//  RNCustomPopUp.swift
//  Alice
//
//  Created by lmcmz on 5/6/19.
//

import BigInt
import PromiseKit
import UIKit

class RNCustomPopUp: UIViewController {
    @IBOutlet var payButton: UIView!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!

    @IBOutlet var RNContainer: UIView!
    @IBOutlet var RNContainerHeight: NSLayoutConstraint!

    var timer: Timer?
    var process: Int = 0
    var toggle: Bool = false

    var toAddress: String!
    var amount: BigUInt!
    var data: Data!
    var successBlock: StringBlock?

    var height: CGFloat = 500

    let footerHeight: CGFloat = 80 + 60 + 20
    let headerHeight: CGFloat = 10 + 60 + 20

    var payView: PayButtonView?

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
        view.layoutIfNeeded()

        addressLabel.text = toAddress
        amountLabel.text = "Amount: " + "\(amount!)"

        payView = PayButtonView.instanceFromNib()
        payButton.addSubview(payView!)
        payView!.fillSuperview()
        payView?.delegate = self

//        let rnView = RNModule.makeView(module: .embeddedView)
//        rnView!.frame = RNContainer.bounds
//        RNContainer.addSubview(rnView!)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
        let rnView = RNModule.makeView(module: .embeddedView)
        rnView!.frame = RNContainer.bounds
        RNContainer.addSubview(rnView!)
    }
}

extension RNCustomPopUp: PayButtonDelegate {
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
        firstly {
            TransactionManager.shared.sendEtherSync(to: toAddress!, amount: amount!, data: data!, password: "")
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
