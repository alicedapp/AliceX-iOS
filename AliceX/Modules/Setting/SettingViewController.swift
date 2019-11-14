//
//  SettingViewController.swift
//  AliceX
//
//  Created by lmcmz on 3/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import PromiseKit
import SPStorkController
import SwiftyUserDefaults
import UIKit

class SettingViewController: BaseViewController {
    @IBOutlet var networkLabel: UILabel!
    @IBOutlet var currencyLabel: UILabel!
//    @IBOutlet var versionLabel: UILabel!

    @IBOutlet var backupView: UIView!

    @IBOutlet var darkLabel: UILabel!
    @IBOutlet var darkTheme: UIView!
    @IBOutlet var darkSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateNetwork),
                                               name: .networkChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateCurrency),
                                               name: .currencyChange, object: nil)
        updateNetwork()
        updateCurrency()

//        versionLabel.text = "v \(Util.version)(\(Util.build))"
        backupView.isHidden = Defaults[\.MnemonicsBackup]

        if #available(iOS 13.0, *) {
            darkSwitch.isOn = traitCollection.userInterfaceStyle == .dark
            darkTheme.isHidden = false
            darkLabel.text = traitCollection.userInterfaceStyle == .dark ? "🌝" : "🌚"
            return
        }
        darkTheme.isHidden = true
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
        let view = BaseAlertView.instanceFromNib(content: "Clean browser cache ?",
                                      confirmBlock: {
                                        BrowserViewController.cleanCache()
        }, cancelBlock: nil)
        
        HUDManager.shared.showAlertView(view: view, backgroundColor: .clear, haptic: .none,
                                        type: .centerFloat, widthIsFull: false, canDismiss: true)
    }

    @IBAction func currencyBtnClicked() {
        let vc = CurrencyViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func walletConnectBtnClicked() {
        let vc = WCControlPanel()
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func aboutBtnClicked() {
        let vc = AboutViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func closeButtonClicked() {
        guard let navi = self.navigationController else {
            dismiss(animated: true, completion: nil)
            return
        }
        navi.dismiss(animated: true, completion: nil)
    }

    // MARK: - mnemonics

    @IBAction func mnemonicsClicked() {
        #if DEBUG
//            HUDManager.shared.showAlertView(view: MnemonicsView.instanceFromNib())
            let vc = MnemonicsViewController()
            navigationController?.pushViewController(vc, animated: true)
        #else
            biometricsVerify()
        #endif
    }

    func biometricsVerify() {
        firstly {
            FaceIDHelper.shared.faceID()
        }.done { _ in
            let vc = MnemonicsViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    @objc func updateNetwork() {
        networkLabel.text = WalletManager.currentNetwork.name
    }

    @objc func updateCurrency() {
        currencyLabel.text = PriceHelper.shared.currentCurrency.rawValue
    }

    @IBAction func darkThemeDidChange(switch _: UISwitch) {
        if #available(iOS 13.0, *) {
            changeThemeAnimation()
            darkLabel.text = darkSwitch.isOn ? "🌝" : "🌚"

            SPStorkTransitioningDelegate.changeBackground()
        }
    }

    // TODO: Change icon
    func changeIcon(to iconName: String) {
        // 1
        guard UIApplication.shared.supportsAlternateIcons else {
            return
        }
        // 2
        UIApplication.shared.setAlternateIconName(iconName, completionHandler: { error in
            // 3
            if let error = error {
                print("App icon failed to change due to \(error.localizedDescription)")
            } else {
                print("App icon changed successfully")
            }
        })
    }
}
