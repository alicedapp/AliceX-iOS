//
//  AboutViewController.swift
//  AliceX
//
//  Created by lmcmz on 14/9/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit

class AboutViewController: BaseViewController {
    @IBOutlet var versionLabel: UILabel!
    @IBOutlet var buildLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        versionLabel.text = "version: \(Util.version)"
        buildLabel.text = "Build: \(Util.build)"
    }

    @IBAction func telegramClicked() {
        if !UIApplication.shared.canOpenURL(Constant.AliceCommunityTelegramScheme) {
            UIApplication.shared.open(Constant.AliceCommunityTelegram, options: [:], completionHandler: nil)
            return
        }

        UIApplication.shared.open(Constant.AliceCommunityTelegramScheme, options: [:], completionHandler: nil)
    }

    @IBAction func twitterClicked() {
        if !UIApplication.shared.canOpenURL(Constant.AliceTwitterScheme) {
            UIApplication.shared.open(Constant.AliceTwitter, options: [:], completionHandler: nil)
            return
        }

        UIApplication.shared.open(Constant.AliceTwitterScheme, options: [:], completionHandler: nil)
    }
    
    @IBAction func privacyClicked() {
        let vc = SampleBrowserViewController.make(url: Setting.privacyURL, title: "Privacy Policy")
        presentAsStork(vc, height: nil, showIndicator: false, showCloseButton: false)
    }

    @IBAction func termClicked() {
        let vc = SampleBrowserViewController.make(url: Setting.termURL, title: "Terms of Service")
        presentAsStork(vc, height: nil, showIndicator: false, showCloseButton: false)
    }
}
