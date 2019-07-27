//
//  SignYesViewController.swift
//  AliceX
//
//  Created by lmcmz on 4/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit

class SignYesViewController: BaseViewController {

    @IBOutlet weak var comfirmTextField: UITextField!
    
    var comfirmBlock: VoidBlock?
    
    class func make(comfirm: VoidBlock) -> SignYesViewController {
        let vc = SignYesViewController()
        vc.comfirmBlock = comfirm
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
        
        var text = comfirmTextField.text?.lowercased()
        text = text?.trimmingCharacters(in: .whitespaces)
        
        if text != "yes" {
            return
        }
        
        guard let block = comfirmBlock else {
            return
        }
        
        block!()
    }
}
