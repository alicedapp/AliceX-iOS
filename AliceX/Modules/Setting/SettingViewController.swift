//
//  SettingViewController.swift
//  AliceX
//
//  Created by lmcmz on 3/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit
import LocalAuthentication

class SettingViewController: BaseViewController {

    @IBOutlet weak var networkLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateNetwork),
                                               name: .networkChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateCurrency),
                                               name: .currencyChange, object: nil)
        updateNetwork()
        updateCurrency()
    }
    
    @IBAction func replaceClicked() {
        let vc = ImportWalletViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func netButtonClicked() {
        let vc = NetworkSwitchViewController()
        navigationController?.pushViewController(vc, animated: true)
//        HUDManager.shared.showAlertViewController(viewController: vc)
    }
    
    @IBAction func cacheButtonClicked() {
        BrowserViewController.cleanCache()
    }
    
    @IBAction func currencyBtnClicked() {
        let vc = CurrencyViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func closeButtonClicked() {
        guard let navi = self.navigationController else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        navi.dismiss(animated: true, completion: nil)
        
    }
    
    // MARK: - mnemonics
    
    @IBAction func mnemonicsClicked() {
        #if DEBUG
            HUDManager.shared.showAlertView(view: MnemonicsView.instanceFromNib())
        #else
            biometricsVerify()
        #endif
    }
    
    @objc func updateNetwork() {
        networkLabel.text = Web3Net.currentNetwork.rawValue.firstUppercased
    }
    
    @objc func updateCurrency() {
        currencyLabel.text = PriceHelper.shared.currentCurrency.rawValue
    }
    
    func biometricsVerify() {
        let myContext = LAContext()
        let myLocalizedReasonString = "Indentity Verify"
        
        var authError: NSError?
        if #available(iOS 8.0, macOS 10.12.1, *) {
            if myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                myContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                         localizedReason: myLocalizedReasonString)
                { success, evaluateError in
                    
                    DispatchQueue.main.async {
                        if success {
                            // User authenticated successfully, take appropriate action
                            HUDManager.shared.showAlertView(view: MnemonicsView.instanceFromNib())
                        } else {
                            // User did not authenticate successfully, look at error and take appropriate action
                            
                        }
                    }
                }
            } else {
                // Could not evaluate policy; look at authError and present an appropriate message to user
            }
        } else {
            // Fallback on earlier versions
        }
    }
}
