//
//  LandingViewController.swift
//  AliceX
//
//  Created by lmcmz on 1/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import BigInt
import SPStorkController
import UIKit
import web3swift

class LandingViewController: BaseViewController {
    @IBOutlet var importBtn: BaseControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        hero.isEnabled = true
        importBtn.hero.id = "importWallet"
    }

    @IBAction func createButtonClicked() {
        WalletManager.createAccount { () -> Void in
            self.popUp()
            WalletCore.loadFromCache()
        }
    }

    @IBAction func importButtonClicked() {
        let vc = ImportWalletViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    func popUp() {
        let vc = MainTabViewController()
        navigationController?.pushViewController(vc, animated: true)
        navigationController?.viewControllers = [vc]
    }

//    override func viewDidAppear(_ animated: Bool) {
//        let to = "0x56519083C3cfeAE833B93a93c843C993bE1D74EA"
//        let value = Web3Utils.parseToBigUInt("0.01", units: .eth)!
//        let data = Data()
//        TransactionManager.showPaymentView(toAddress: to,
//                                           amount: value,
//                                           data: data,
//                                           symbol: "ETH",
//                                           success: { (tx) -> Void in
//                                            print(tx)
//        })
//    }
}
