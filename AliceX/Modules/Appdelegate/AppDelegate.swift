//
//  AppDelegate.swift
//  AliceX
//
//  Created by lmcmz on 7/6/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import CodePush
import Firebase
import IQKeyboardManagerSwift
import React
import SPStorkController
import RNFirebase

private var navi: UINavigationController?
private var bridge: RCTBridge?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions
        _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        var jsCodeLocation: URL?

        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true

        WalletManager.loadFromCache()
        onBackgroundThread {
            PriceHelper.shared.fetchFromCache()
        }

        bridge = RCTBridge(bundleURL: sourceURL(bridge: bridge), moduleProvider: nil, launchOptions: nil)
        #if RCT_DEV
            bridge?.moduleClasses = RCTDevLoadingView.self
        #endif

        window = UIWindow(frame: UIScreen.main.bounds)

        window?.backgroundColor = WalletManager.currentNetwork.backgroundColor
        SPStorkTransitioningDelegate.backgroundColor = WalletManager.currentNetwork.backgroundColor

        var vc = UIViewController()

        if WalletManager.hasWallet() {
            WalletCore.loadFromCache()
            vc = MainTabViewController()
        } else {
            vc = LandingViewController()
        }

        let rootVC = BaseNavigationController(rootViewController: vc)
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
        navi = rootVC

        PinManager.addFloatVC(list: [BrowserWrapperViewController.nameOfClass,
                                     BaseRNAppViewController.nameOfClass,
                                     HomeWebBrowserWrapper.nameOfClass])

        WalletManager.shared.checkMnemonic()

        #if DEBUG
            test()
        #endif

        return true
    }

    func test() {
//        WalletCore.shared.testBNB()
//        WalletManager.shared.test()
//        WalletCore.shared.binanceSend(toAddress: "bnb1k2emmlq5v5yz4nyzhfcjtdgkveeghrq53ragzp", value: BigUInt(1)).done { txHash in
//            print("AAAAA: \(txHash)")
//        }.catch { error in
//            print(error.localizedDescription)
//        }
    }

    func sourceURL(bridge _: RCTBridge?) -> URL? {
        #if DEBUG
            return RCTBundleURLProvider.sharedSettings().jsBundleURL(forBundleRoot: "index", fallbackResource: nil)
        #else
            return CodePush.bundleURL()
        #endif
    }

    func applicationWillResignActive(_: UIApplication) {
        HideHelper.shared.start()
    }

    func applicationDidEnterBackground(_: UIApplication) {}

    func applicationWillEnterForeground(_: UIApplication) {}

    func applicationDidBecomeActive(_: UIApplication) {
        HideHelper.shared.stop()
    }

    func applicationWillTerminate(_: UIApplication) {}

    class func rnBridge() -> RCTBridge {
        return bridge!
    }

    func application(_: UIApplication, open url: URL, options _: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return handleAliceURL(url: url)
    }

    func application(_: UIApplication, continue userActivity: NSUserActivity, restorationHandler _: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        guard let url = userActivity.webpageURL else {
            return false
        }

        return handleAliceURL(url: url)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        RNFirebaseNotifications.instance().didReceiveRemoteNotification(userInfo, fetchCompletionHandler: completionHandler)
    }

    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        RNFirebaseMessaging.instance().didRegister(notificationSettings)
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        RNFirebaseMessaging.instance().didReceiveRemoteNotification(response.notification.request.content.userInfo)
        completionHandler()
    }
}
