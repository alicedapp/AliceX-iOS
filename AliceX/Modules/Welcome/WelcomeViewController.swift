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
        WalletManager.createAccount { () -> (Void) in
            let mnemonics = KeychainHepler.fetchKeychain(key: Setting.MnemonicsKey)
            self.nLable.text = mnemonics
            
            let address = WalletManager.wallet?.address
            self.label.text = address
            
        }
    }
    
    @IBAction func importAccount() {
        let mnemonics = impLable.text
        
        do {
            try WalletManager.importAccount(mnemonics: mnemonics!, completion: { () -> (Void) in
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
        
        let ABI = """
[{"constant":false,"inputs":[],"name":"cookingOrder","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[],"name":"finishOrder","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_foodItem","type":"string"},{"name":"_name","type":"string"}],"name":"setOrder","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_orderStatus","type":"string"}],"name":"setOrderStatus","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"anonymous":false,"inputs":[{"indexed":false,"name":"foodItem","type":"string"},{"indexed":false,"name":"name","type":"string"}],"name":"FoodFinished","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"foodItem","type":"string"},{"indexed":false,"name":"name","type":"string"}],"name":"OrderReceived","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"orderStatus","type":"string"}],"name":"OrderStatus","type":"event"},{"constant":true,"inputs":[],"name":"getOrder","outputs":[{"name":"","type":"string"},{"name":"","type":"string"},{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"}]
"""
        
        try! TransactionManager.callSmartContract(contractAddress: "0x68F7202dcb25360FA6042F6739B7F6526AfcA66E", method: "setOrder", ABI: ABI, parameter: ["Burrito", "Hao"])
    }
    
    @IBAction func popUp() {
        let vc = UIViewController()
        let jsCodeLocation = URL(string: "http://localhost:8081/index.bundle?platform=ios")
        let rnView = RCTRootView(bundleURL: jsCodeLocation, moduleName: "alice", initialProperties: nil, launchOptions: nil)
        vc.view = rnView
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func payment() {
        TransactionManager.showPaymentView(toAddress: "0xA1b02d8c67b0FDCF4E379855868DeB470E169cfB", amount: "0.001", success: { (tx) -> (Void) in
            print(tx)
        })
    }
}
