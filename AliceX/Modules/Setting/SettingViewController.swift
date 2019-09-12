//
//  SettingViewController.swift
//  AliceX
//
//  Created by lmcmz on 3/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import PromiseKit
import UIKit

class SettingViewController: BaseViewController {
    @IBOutlet var networkLabel: UILabel!
    @IBOutlet var currencyLabel: UILabel!
    
    @IBOutlet var versionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateNetwork),
                                               name: .networkChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateCurrency),
                                               name: .currencyChange, object: nil)
        updateNetwork()
        updateCurrency()
        
        versionLabel.text = "v \(Util.version)(\(Util.build))"
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
            dismiss(animated: true, completion: nil)
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

    func biometricsVerify() {
        firstly {
            FaceIDHelper.shared.faceID()
        }.done { _ in
            HUDManager.shared.showAlertView(view: MnemonicsView.instanceFromNib())
        }
    }

    @objc func updateNetwork() {
        networkLabel.text = WalletManager.currentNetwork.name
    }

    @objc func updateCurrency() {
        currencyLabel.text = PriceHelper.shared.currentCurrency.rawValue
    }
}
