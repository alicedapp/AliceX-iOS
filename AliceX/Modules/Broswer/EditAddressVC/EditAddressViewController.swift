//
//  EditAddressViewController.swift
//  AliceX
//
//  Created by lmcmz on 12/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit

class EditAddressViewController: BaseViewController {

    @IBOutlet weak var addressField: UITextField!
    
    weak var browerRef: BrowserViewController?
    var address: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressField.text = address
        addressField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addressField.becomeFirstResponder()
    }
    
//    @IBAction func closeButtonClicked(){
//        view.endEditing(true)
//        self.hero.dismissViewController()
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        view.becomeFirstResponder()
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

extension EditAddressViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let url = URL(string: (self.addressField.text!.addHttpPrefix())) else {
            HUDManager.shared.showError(text: "Check the address")
            return false
        }
        
        self.browerRef!.goTo(url: url)
        self.backButtonClicked(sender: self.addressField)
        return true
    }
}
