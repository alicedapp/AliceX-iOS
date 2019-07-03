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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateNetwork),
                                               name: .networkChange, object: nil)
        updateNetwork()
    }
    
    @IBAction func mnemonicsClicked() {
        
        biometricsVerify()
    }
    
    @IBAction func netButtonClicked() {
        let alert = UIAlertController(title: "Switch Network",
                                      message: "Change transaction blockchain",
                                      preferredStyle: .actionSheet)
        
        let pickerViewValues: [String] = Web3NetEnum.allCases.map
        { "\($0)".firstUppercased }.filter{$0 != "Custom"}
        
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0,
                                                                       row: pickerViewValues
            .firstIndex(of: Web3Net.fetchFromCache().firstUppercased) ?? 0)
        
        alert.addPickerView(values: [pickerViewValues],
                            initialSelection: pickerViewSelectedValue)
        { vc, picker, index, values in
            let string = values[0][index.row].lowercased()
            Web3Net.upodateNetworkSelection(type: Web3NetEnum(rawValue: string)!)
        }
        
        alert.addAction(title: "Done", style: .cancel)
        alert.show()
    }
    
    @objc func updateNetwork() {
        networkLabel.text = Web3Net.currentNetwork.rawValue.firstUppercased
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
