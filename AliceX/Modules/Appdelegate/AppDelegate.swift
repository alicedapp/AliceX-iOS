//
//  AppDelegate.swift
//  AliceX
//
//  Created by lmcmz on 7/6/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import React

private var navi: UINavigationController?
private var bridge: RCTBridge?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        WalletManager.loadFromCache()
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.clear
        window?.makeKeyAndVisible()
        
        let vc = WelcomeViewController()
        let rootVC = UINavigationController.init(rootViewController: vc)
        navi = rootVC
        self.window?.rootViewController = rootVC
        
        IQKeyboardManager.shared.enable = true
        
        let jsCodeLocation = URL(string: "http://localhost:8081/index.bundle?platform=ios")
        bridge = RCTBridge(bundleURL: jsCodeLocation, moduleProvider: nil, launchOptions: nil)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {

    }

    class func rnBridge() -> RCTBridge {
        return bridge!
    }
}
