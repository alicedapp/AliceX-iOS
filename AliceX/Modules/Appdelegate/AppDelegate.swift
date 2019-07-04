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
        let jsCodeLocation = URL(string: "http://localhost:8081/index.bundle?platform=ios")
        bridge = RCTBridge(bundleURL: jsCodeLocation, moduleProvider: nil, launchOptions: nil)

        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.clear
        
        var vc = UIViewController()
        
        if WalletManager.hasWallet() {
            vc = RNModule.makeViewController(module: .alice)
//            vc = SettingViewController()
        } else {
            vc = LandingViewController()
        }
        
        let rootVC = BaseNavigationController.init(rootViewController: vc)
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
        navi = rootVC
    
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
