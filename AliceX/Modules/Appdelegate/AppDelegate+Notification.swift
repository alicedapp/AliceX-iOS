//
//  AppDelegate+Notification.swift
//  AliceX
//
//  Created by lmcmz on 28/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Firebase
import Foundation
// import RNFirebase
import UserNotifications

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo

        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }

        // Print full message.
        print(userInfo)

        // Change this to your preferred presentation option
        completionHandler([.badge, .alert, .sound])
    }

    func userNotificationCenter(_: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }

//        RNFirebaseMessaging.instance().didReceiveRemoteNotification(response.notification.request.content.userInfo)

        // Print full message.
        print(userInfo)

        completionHandler()
    }

    func userNotificationCenter(_: UNUserNotificationCenter, openSettingsFor _: UNNotification?) {
        print("CCCCC")
    }
}

// [END ios_10_message_handling]

//

// MARK: - Router

extension AppDelegate {
    func router(path: String) {
        let component = path.split(separator: "/")
        if let first = component.first, String(first) == "rn" {
            let remainStr = component.dropFirst()
            let router = remainStr.joined(separator: "/")
            let dict = ["navigationRoute": router]
            let vc = BaseRNViewController()
            let rnView = RCTRootView(bridge: AppDelegate.rnBridge(), moduleName: "alice", initialProperties: dict)
            vc.view = rnView
            let topVC = UIApplication.topViewController()
            topVC?.navigationController?.pushViewController(vc, animated: true)
        }

        if path.hasPrefix("browser/") {
            let remainStr = path.dropFirst(8)
            let vc = BrowserWrapperViewController.make(urlString: String(remainStr))
            let topVC = UIApplication.topViewController()
            topVC?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
