//
//  ImportWalletViewController.swift
//  AliceX
//
//  Created by lmcmz on 1/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit

class ImportWalletViewController: BaseViewController {
    @IBOutlet var importBtn: BaseControl!

    @IBOutlet var buttonLabel: UILabel!
    @IBOutlet var textView: UITextView!

    var placeholderLabel: UILabel!
    var mnemonic: String = ""
    var buttonText: String = "Import Wallet"

    class func make(buttonText: String, mnemonic: String) -> ImportWalletViewController {
        let vc = ImportWalletViewController()
        vc.buttonText = buttonText
        vc.mnemonic = mnemonic
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hero.isEnabled = true
        hideKeyboardWhenTappedAround()
        importBtn.hero.id = "importWallet"

        textView.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Mnemonic"
        placeholderLabel.font = UIFont.systemFont(ofSize: (textView.font?.pointSize)!, weight: .medium)
        placeholderLabel.sizeToFit()
        textView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (textView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !textView.text.isEmpty

        buttonLabel.text = buttonText

        if !mnemonic.isEmptyAfterTrim() {
            textView.text = mnemonic
            placeholderLabel.isHidden = true
        }
    }

    @IBAction func importButtonClicked() {
        var mnemonics = textView.text
        mnemonics = mnemonics?.trimmingCharacters(in: .whitespaces)
        if mnemonics?.count == 0 {
            HUDManager.shared.showError(text: "mnemonics is empty")
            return
        }

        mnemonics = mnemonics?.lowercased()

        do {
            try WalletManager.importWallet(mnemonics: mnemonics!, completion: { () -> Void in
                let vc = MainTabViewController()
                self.navigationController?.pushViewController(vc, animated: true)
                self.navigationController?.viewControllers = [vc]
                WalletCore.shared.loadFromCache()
            })
        } catch let error as WalletError {
            HUDManager.shared.showError(text: error.errorDescription)
        } catch {
            HUDManager.shared.showError(text: "Incorrect seed phrase")
            print(error.localizedDescription)
        }
    }
}

extension ImportWalletViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}
