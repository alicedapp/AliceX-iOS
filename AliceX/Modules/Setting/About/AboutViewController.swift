//
//  AboutViewController.swift
//  AliceX
//
//  Created by lmcmz on 14/9/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Firebase
import UIKit

class AboutViewController: BaseViewController {
    @IBOutlet var versionLabel: UILabel!
    @IBOutlet var buildLabel: UILabel!
    @IBOutlet var logoImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        versionLabel.text = "version: \(Util.version)"
        buildLabel.text = "Build: \(Util.build)"

        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress(gesture:)))
        longPress.minimumPressDuration = 4
        logoImage.addGestureRecognizer(longPress)
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

    @objc func longPress(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            InstanceID.instanceID().instanceID { result, error in
                if let error = error {
                    print("Error fetching remote instance ID: \(error)")
                } else if let result = result {
                    print("Remote instance ID token: \(result.token)")
                    UIPasteboard.general.string = result.token
                    HUDManager.shared.showSuccess(text: "FCM Token Copied")
                }
            }
        default:
            break
        }
    }
}
