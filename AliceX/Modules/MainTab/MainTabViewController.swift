//
//  MainTabViewController.swift
//  AliceX
//
//  Created by lmcmz on 26/10/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Pageboy
import SwiftyUserDefaults
import UIKit

class MainTabViewController: PageboyViewController {
    @IBOutlet var tabcontainer: UIStackView!
    @IBOutlet var tab1Conatiner: UIView!
    @IBOutlet var tab2Conatiner: UIView!
    @IBOutlet var tab3Conatiner: UIView!

    @IBOutlet var tab1Icon: UIImageView!
    @IBOutlet var tab2Icon: UIImageView!
    @IBOutlet var tab3Icon: UIImageView!

    @IBOutlet var badge: UIView!

    var tabs = MainTab.allCases

    var defaultPage: MainTab = MainTab.asset

    var vcs: [UIViewController] = []
    let minVC = MiniAppViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        hero.isEnabled = true
        view.isHeroEnabledForSubviews = true
        view.isHeroEnabled = true

        minVC.tabRef = tabcontainer
        vcs = [minVC, AssetViewController(), SettingViewController.make(hideBackButton: true)]

        vcs.forEach { vc in
            vc.hero.isEnabled = true
            vc.view.isHeroEnabledForSubviews = true
            vc.view.isHeroEnabled = true
        }

        dataSource = self
        delegate = self
        bounces = false
        view.backgroundColor = .clear
//        Defaults[\.isFirstTimeOpen] = false

        for tag in 1 ... 3 {
            guard let tagView = view.viewWithTag(tag) else {
                continue
            }
            tagView.layer.shadowColor = UIColor(hex: "#000000", alpha: 0.5).cgColor
            tagView.layer.shadowOpacity = 0.5
            tagView.layer.shadowOffset = CGSize(width: 0, height: 2)
            tagView.layer.shadowRadius = 5
        }

        tab2Icon.alpha = 0

        badge.isHidden = Defaults[\.MnemonicsBackup]

        NotificationCenter.default.addObserver(self, selector: #selector(mnemonicBackuped), name: .mnemonicBackuped, object: nil)

        registerNotification()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func mnemonicBackuped() {
        badge.isHidden = Defaults[\.MnemonicsBackup]
    }

    func registerNotification() {
        UNUserNotificationCenter.current().delegate = UIApplication.shared.delegate! as! UNUserNotificationCenterDelegate
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        UIApplication.shared.registerForRemoteNotifications()
    }

    @IBAction func tabClick(button: UIControl) {
        let tag = button.tag - 1
        scrollToPage(.at(index: tag), animated: true)
    }
}

extension MainTabViewController: PageboyViewControllerDataSource {
    func numberOfViewControllers(in _: PageboyViewController) -> Int {
        return tabs.count
    }

    func viewController(for _: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
//        let tab = tabs[index]
        return vcs[index]
    }

    func defaultPage(for _: PageboyViewController) -> PageboyViewController.Page? {
        return .at(index: defaultPage.rawValue)
    }
}

extension MainTabViewController: PageboyViewControllerDelegate {
    func pageboyViewController(_: PageboyViewController,
                               willScrollToPageAt _: PageboyViewController.PageIndex,
                               direction _: PageboyViewController.NavigationDirection,
                               animated _: Bool) {
    }

    func pageboyViewController(_: PageboyViewController,
                               didCancelScrollToPageAt _: PageboyViewController.PageIndex,
                               returnToPageAt _: PageboyViewController.PageIndex) {
    }

    func pageboyViewController(_: PageboyViewController,
                               didScrollTo position: CGPoint,
                               direction _: PageboyViewController.NavigationDirection,
                               animated _: Bool) {
        let x = position.x
        if x >= 0, x <= 1.0 {
            let alpha = x
            tab1Icon.alpha = alpha
            tab2Icon.alpha = 1 - alpha

            if minVC.isTriggle {
                tabcontainer.alpha = x
                return
            }
        }

        if x >= 1, x <= 2.0 {
            let alpha = x - 1
            tab2Icon.alpha = alpha
            tab3Icon.alpha = 1 - alpha
        }
    }

    func pageboyViewController(_: PageboyViewController,
                               didScrollToPageAt index: PageboyViewController.PageIndex,
                               direction _: PageboyViewController.NavigationDirection,
                               animated _: Bool) {
        if index != MainTab.mini.rawValue {
            tabcontainer.alpha = 1
            return
        }

        tabcontainer.alpha = minVC.isTriggle ? 0 : 1
    }

    func pageboyViewController(_: PageboyViewController,
                               didReloadWith _: UIViewController,
                               currentPageIndex _: PageIndex) {}
}
