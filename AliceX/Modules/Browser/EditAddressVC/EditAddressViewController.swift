//
//  EditAddressViewController.swift
//  AliceX
//
//  Created by lmcmz on 12/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit

class EditAddressViewController: BaseViewController {
    @IBOutlet var addressField: UITextField!

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
            if view.frame.origin.y == 0 {
                view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification _: NSNotification) {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }

    class func makeUrlIfNeeded(urlString: String) -> String {
        var urlString = urlString

        if !urlString.hasPrefix("http://"), !urlString.hasPrefix("https://") {
            urlString = urlString.addHttpPrefix()
        }

        if urlString.validateUrl() {
            return urlString
        }

        if urlString.hasPrefix("http://") {
            urlString = String(urlString.dropFirst(7))
        }

        if urlString.hasPrefix("https://") {
            urlString = String(urlString.dropFirst(8))
        }

        urlString = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        urlString = "https://www.google.com/search?q=\(urlString)"

        return urlString
    }
}

extension EditAddressViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_: UITextField) -> Bool {
        var urlString = addressField.text!
        urlString = EditAddressViewController.makeUrlIfNeeded(urlString: urlString)
        let url = URL(string: urlString)
        browerRef!.goTo(url: url!)
        backButtonClicked()
        return true
    }
}
