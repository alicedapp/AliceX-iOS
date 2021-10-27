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
    @IBOutlet var accountLabel: UILabel!
    @IBOutlet var networkLabel: UILabel!
    @IBOutlet var currencyLabel: UILabel!
    @IBOutlet var scrollView: UIScrollView!

    var hideBackButton: Bool = false
    @IBOutlet var backButton: UIView!

    @IBOutlet var backupView: UIView!
    @IBOutlet var newBackupView: UIView!

    @IBOutlet var darkLabel: UILabel!
    @IBOutlet var darkTheme: UIView!
    @IBOutlet var darkSwitch: UISwitch!
    @IBOutlet var darkImage: UIImageView!
    @IBOutlet var notiSwitch: UISwitch!

    class func make(hideBackButton: Bool) -> SettingViewController {
        let vc = SettingViewController()
        vc.hideBackButton = hideBackButton
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateNetwork),
                                               name: .networkChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateCurrency),
                                               name: .currencyChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(mnemonicBackuped),
                                               name: .mnemonicBackuped, object: nil)

        updateNetwork()
        updateCurrency()

        let isBackuped = Defaults[\.MnemonicsBackup]
        backupView.isHidden = isBackuped
        newBackupView.isHidden = isBackuped
        accountLabel.isHidden = !newBackupView.isHidden
        if !isBackuped {
            //            UIView.animate(withDuration: 0.1, delay: 0.5, options: [.autoreverse, .repeat, .curveEaseInOut], animations: {
            //                self.backupView.transform = .init(translationX: 0, y: -2)
            //            }) { _ in
            //                self.backupView.transform = .identity
            //            }
        }

        accountLabel.text = WalletManager.currentAccount?.name

        backButton.isHidden = hideBackButton

        notiSwitch.isOn = UIApplication.shared.isRegisteredForRemoteNotifications
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            onMainThread {
                if settings.authorizationStatus != .authorized {
                    self.notiSwitch.isOn = false
                }
            }
        }

        if hideBackButton {
            scrollView.alwaysBounceVertical = true
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        }

        if #available(iOS 13.0, *) {
            darkSwitch.isOn = traitCollection.userInterfaceStyle == .dark
            darkTheme.isHidden = false
            darkLabel.text = darkSwitch.isOn ? "🌝" : "🌚"
            darkImage.image = darkSwitch.isOn ? UIImage(named: "light-mode-setting") : UIImage(named: "dark-mode-setting")
            return
        }
        darkTheme.isHidden = true
    }

    @objc func mnemonicBackuped() {
        backupView.isHidden = Defaults[\.MnemonicsBackup]
        newBackupView.isHidden = Defaults[\.MnemonicsBackup]
    }

    @IBAction func replaceClicked() {
        let vc = ImportWalletViewController.make(buttonText: "Replace Wallet", mnemonic: "")
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

    @IBAction func accountBtnClicked() {
        let vc = SwitchAccountViewController()
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
        if WalletManager.currentNetwork == .main {
            networkLabel.textColor = UIColor(hex: "B1B1B1")
            return
        }
        networkLabel.textColor = WalletManager.currentNetwork.color
    }

    @objc func updateCurrency() {
        currencyLabel.text = PriceHelper.shared.currentCurrency.rawValue
    }

    @IBAction func notificationChange(switcher: UISwitch) {
        if switcher.isOn {
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                onMainThread {
                    if settings.authorizationStatus != .authorized {
                        let url = URL(string: UIApplication.openSettingsURLString)!
                        if UIApplication.shared.canOpenURL(url) {
                            _ = UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    } else {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
            return
        }
        UIApplication.shared.unregisterForRemoteNotifications()
    }

    @IBAction func darkThemeDidChange(switch _: UISwitch) {
        if #available(iOS 13.0, *) {
            changeThemeAnimation()
            darkLabel.text = darkSwitch.isOn ? "🌝" : "🌚"
            darkImage.image = darkSwitch.isOn ? UIImage(named: "light-mode-setting") : UIImage(named: "dark-mode-setting")
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
