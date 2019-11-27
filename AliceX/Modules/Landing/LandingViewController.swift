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
import VBFPopFlatButton
import BonMot

class LandingViewController: BaseViewController {
    
    @IBOutlet var importBtn: BaseControl!
    
    @IBOutlet var conditionContainer: UIView!
    @IBOutlet var checkBox: VBFPopFlatButton!
    @IBOutlet var conditionLabel: UILabel!
    
    var isChecked: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hero.isEnabled = true
        importBtn.hero.id = "importWallet"
        
        checkBox.currentButtonType = .buttonSquareType
        checkBox.currentButtonStyle = .buttonRoundedStyle
        checkBox.lineThickness = 3
        checkBox.lineRadius = 3
        checkBox.tintColor = UIColor.gray
    }

    @IBAction func checkClicked() {
        isChecked = !isChecked
        checkBox.currentButtonType = .buttonOkType
        checkBox.tintColor = AliceColor.green
    }
    
    @IBAction func createButtonClicked() {
        
        if !isChecked {
            shakeAnimation()
            return
        }
        
        WalletManager.createAccount { () -> Void in
            self.popUp()
            WalletCore.loadFromCache()
        }
    }

    @IBAction func importButtonClicked() {
        
        if !isChecked {
            shakeAnimation()
            return
        }
        
        let vc = ImportWalletViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func shakeAnimation() {
        UIImpactFeedbackGenerator.init(style: .medium).impactOccurred()
        UIView.animate(withDuration: 0.2, delay: 0, options: [.autoreverse, .repeat], animations: {
            self.conditionContainer.transform = .init(translationX: 15, y: 0)
        }) { _ in
            
        }
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
