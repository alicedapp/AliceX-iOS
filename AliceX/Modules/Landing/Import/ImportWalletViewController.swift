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

    @IBOutlet var textView: UITextView!

    var placeholderLabel: UILabel!
    
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
            try WalletManager.importAccount(mnemonics: mnemonics!, completion: { () -> Void in
                let vc = RNModule.makeViewController(module: .alice)
                self.navigationController?.pushViewController(vc, animated: true)
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
