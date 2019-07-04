//
//  LandingViewController.swift
//  AliceX
//
//  Created by lmcmz on 1/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit
import SPStorkController

class LandingViewController: BaseViewController {

    @IBOutlet var importBtn: BaseControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hero.isEnabled = true
        importBtn.hero.id = "importWallet"
    }
    
    @IBAction func createButtonClicked() {
        WalletManager.createAccount { () -> Void in
            self.popUp()
        }
    }
    
    @IBAction func importButtonClicked() {
        let vc = ImportWalletViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func popUp() {
        let vc = RNModule.makeViewController(module: .alice)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
