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

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hero.isEnabled = true
        importBtn.hero.id = "importWallet"
    }
    
    @IBAction func importButtonClicked() {
        let mnemonics = textView.text
        
        do {
            try WalletManager.importAccount(mnemonics: mnemonics!, completion: { () -> Void in
                let vc = RNModule.makeViewController(module: .alice)
                self.navigationController?.pushViewController(vc, animated: true)
            })
        } catch {
            HUDManager.shared.showError(text: "Incorrect seed phrase")
            print(error.localizedDescription)
        }
    }
}
