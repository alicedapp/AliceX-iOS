//
//  WelcomeViewController.swift
//  AliceX
//
//  Created by lmcmz on 7/6/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit

class WelcomeViewController: BaseViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var nLable: UITextView!
    
    @IBOutlet weak var impLable: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nLable.isEditable = false
        
        let mnemonics = KeychainHepler.fetchKeychain(key: Setting.MnemonicsKey)
        nLable.text = mnemonics
        
        let address = WalletManager.wallet?.address
        label.text = address
        
    }
    
    @IBAction func createAccount() {
        WalletManager.createAccount { () -> Void in
            let mnemonics = KeychainHepler.fetchKeychain(key: Setting.MnemonicsKey)
            self.nLable.text = mnemonics
            
            let address = WalletManager.wallet?.address
            self.label.text = address
            
        }
    }
    
    @IBAction func importAccount() {
        let mnemonics = impLable.text
        
        do {
            try WalletManager.importAccount(mnemonics: mnemonics!, completion: { () -> Void in
                let mnemonics = KeychainHepler.fetchKeychain(key: Setting.MnemonicsKey)
                self.nLable.text = mnemonics
                
                let address = WalletManager.wallet?.address
                self.label.text = address
            })
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func callSmartContract() {
        
    }
    
    @IBAction func popUp() {
        let vc = UIViewController()
        let rnView = RCTRootView(bridge: AppDelegate.rnBridge(), moduleName: "alice", initialProperties: nil)
        vc.view = rnView
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func payment() {
        TransactionManager.showPaymentView(toAddress: "0xA1b02d8c67b0FDCF4E379855868DeB470E169cfB",
                                           amount: "0.001", success: { (tx) -> Void in
            print(tx)
        })
    }
}
