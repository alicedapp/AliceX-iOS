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
//import RNFirebase
import SPStorkController
import UserNotifications

import BigInt
import PromiseKit

private var navi: UINavigationController?
private var bridge: RCTBridge?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions
        launchOption: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        var jsCodeLocation: URL?

        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        
        IQKeyboardManager.shared.enable = true

        WalletManager.loadFromCache()
        onBackgroundThread {
            PriceHelper.shared.fetchFromCache()
            TransactionRecordHelper.shared.loadFromCache()
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
            WalletCore.shared.loadFromCache()
            vc = MainTabViewController()
        } else {
            vc = LandingViewController()
        }

        let rootVC = BaseNavigationController(rootViewController: vc)
        rootVC.hero.isEnabled = true
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
        navi = rootVC

        PinManager.addFloatVC(list: [BrowserWrapperViewController.nameOfClass,
                                     BaseRNAppViewController.nameOfClass,
                                     HomeWebBrowserWrapper.nameOfClass])

        WalletManager.shared.checkMnemonic()
        UNUserNotificationCenter.current().delegate = self
        
        #if DEBUG
            test()
            Fabric.sharedSDK().debug = true
        #endif
        if let option = launchOption,
            let userInfo = option[UIApplication.LaunchOptionsKey.remoteNotification]  as? [AnyHashable: Any],
            let aps = userInfo["aps"] as? [AnyHashable: Any],
            let path = aps["path"] as? String {
            
            router(path: path)
            print(userInfo)
        }
        
        return true
    }

    func test() {
        
        InstanceID.instanceID().instanceID { (result, error) in
          if let error = error {
            print("Error fetching remote instance ID: \(error)")
          } else if let result = result {
            print("Remote instance ID token: \(result.token)")
          }
        }
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

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        if application.applicationState != .active,
        let path = userInfo["path"] as? String {
            router(path: path)
        }
    
//        Messaging.messaging().appDidReceiveMessage(userInfo)
        print(userInfo)
    }
    
    

    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(" Push notification received:")
        
//        if (application.applicationState == .active) {
            /// Foreground
            // TODO
//            return
//        }
        
//        RNFirebaseNotifications.instance().didReceiveRemoteNotification(userInfo, fetchCompletionHandler: completionHandler)
        
//        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        if let messageID = userInfo[gcmMessageIDKey] {
          print("Message ID: \(messageID)")
        }
        
        if let aps = userInfo["aps"] as? [AnyHashable: Any], let path = aps["path"] as? String{
            router(path: path)
        }
        
        print(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }

    func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print(" APNS token: \(token)")
        Messaging.messaging().apnsToken = deviceToken
    }

    func application(_: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
//        RNFirebaseMessaging.instance().didRegister(notificationSettings)
    }

    func application(_: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
}
