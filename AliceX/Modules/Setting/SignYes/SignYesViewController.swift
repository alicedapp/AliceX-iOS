//
//  SignYesViewController.swift
//  AliceX
//
//  Created by lmcmz on 4/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit

class SignYesViewController: BaseViewController {
    @IBOutlet var confirmTextField: UITextField!

    var confirmBlock: VoidBlock?

    class func make(confirm: VoidBlock) -> SignYesViewController {
        let vc = SignYesViewController()
        vc.confirmBlock = confirm
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }

    @IBAction func cancelClicked() {
        HUDManager.shared.dismiss()
    }

    @IBAction func confirmClicked() {
        var text = confirmTextField.text?.lowercased()
        text = text?.trimmingCharacters(in: .whitespaces)

        if text != "yes" {
            return
        }

        guard let block = confirmBlock else {
            return
        }

        block!()
    }
}
