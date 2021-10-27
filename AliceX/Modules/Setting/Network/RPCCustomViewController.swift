//
//  NetworkCustomViewController.swift
//  AliceX
//
//  Created by lmcmz on 11/9/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit
import web3swift

class RPCCustomViewController: BaseViewController {
    @IBOutlet var deleteButton: UIControl!
    @IBOutlet var namefield: UITextField!
    @IBOutlet var textfield: UITextField!
    @IBOutlet var testLabel: UILabel!

    @IBOutlet var updateLabel: UILabel!

    var passed: Bool = false
    var testWeb3: web3!

    var model: Web3NetModel?
    var isUpdate: Bool = false

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        namefield.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.endEditing(true)
    }

    class func make(model: Web3NetModel) -> RPCCustomViewController {
        let vc = RPCCustomViewController()
        vc.isUpdate = true
        vc.model = model
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        deleteButton.isHidden = !isUpdate
        updateLabel.text = isUpdate ? "Update" : "Add"

        namefield.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor(hex: "#9D9D9D")])

        textfield.attributedPlaceholder = NSAttributedString(string: "URL", attributes: [NSAttributedString.Key.foregroundColor: UIColor(hex: "#9D9D9D")])

        if isUpdate {
            namefield.text = model?.name
            textfield.text = model?.rpcURL
        }

        NotificationCenter.default.addObserver(self, selector: #selector(addRPCSuccess), name: .customRPCChange, object: nil)

        //        NotificationCenter.default.addObserver(self, selector: #selector(addRPCSuccess), name: .updateCustomRPC, object: nil)
        // Do any additional setup after loading the view.
    }

    func testFailed() {
        animation()
        testLabel.text = "❌ Failed"
        testLabel.textColor = Color.red
        delay(3) {
            self.animation()
            self.testLabel.text = "Test"
            self.testLabel.textColor = UIColor.lightGray
        }
    }

    func testSuccess() {
        animation()
        testLabel.text = "✅ Pass"
        delay(3) {
            self.animation()
            self.testLabel.text = "Test"
            self.testLabel.textColor = UIColor.lightGray
        }
    }

    func animation() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        transition.type = CATransitionType(rawValue: "cube")
        transition.subtype = CATransitionSubtype.fromBottom
        testLabel.layer.add(transition, forKey: "country1_animation")
        //        transition.subtype = CATransitionSubtype.fromTop
        //        country2.layer.add(transition, forKey: "country2_animation")
    }

    @IBAction func testClicked() {
        guard let string = textfield.text else {
            testFailed()
            passed = false
            return
        }

        if string.isEmptyAfterTrim() {
            testFailed()
            passed = false
            return
        }

        do {
            guard let url = URL(string: string) else {
                testFailed()
                passed = false
                return
            }
            testWeb3 = try Web3.new(url)
            testSuccess()
            passed = true
        } catch {
            testFailed()
            passed = false
        }
    }

    @IBAction func pasteClicked() {
        guard let string = UIPasteboard.general.string else {
            return
        }
        textfield.text = string
    }

    @IBAction func addClicked() {
        testClicked()
        if !passed {
            testFailed()
            return
        }

        guard let net = testWeb3!.provider.network else {
            testFailed()
            return
        }

        let name = namefield.text!.isEmptyAfterTrim() ? "Custom" : namefield.text?.trimed()
        let model = Web3NetModel(name: name,
                                 chainID: Int(net.chainID),
                                 color: UIColor.lightGray.toHexString(),
                                 rpcURL: textfield.text?.trimed())

        if isUpdate {
            WalletManager.shared.updateRPC(oldModel: self.model!, newModel: model)
            return
        }

        WalletManager.shared.addRPC(model: model)
    }

    @objc func addRPCSuccess() {
        HUDManager.shared.showSuccess(text: "Custom RPC Updated")
        backButtonClicked()
    }

    func deleteRPC() {
        WalletManager.shared.deleteRPC(model: model!)
    }

    @IBAction func deleteButtonClick() {
        //        title: "Alert",
        //        content: "Are you sure, you want delete this RPC?",
        //        confirmText: "confirm",
        //        cancelText: "Cancel"
        let view = BaseAlertView.instanceFromNib(content: "Are you sure, you want delete this RPC?",
                                                 confirmBlock: {
                                                    self.deleteRPC()
                                                 }) {
            HUDManager.shared.dismiss()
        }

        HUDManager.shared.showAlertView(view: view,
                                        backgroundColor: .clear,
                                        haptic: .none,
                                        type: .centerFloat,
                                        widthIsFull: false)
    }
}
