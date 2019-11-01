//
//  ShareHelper.swift
//  AliceX
//
//  Created by lmcmz on 30/9/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation

class ShareHelper {
    static func share(text: String?, image: UIImage?, urlString: String?) {
//        HUDManager.shared.dismiss()

        var shareArray: [Any] = []

        if let shareText = text {
            if !shareText.isEmpty {
                shareArray.append(shareText)
            }
        }

        if let urlStr = urlString, let url = URL(string: urlStr) {
            shareArray.append(url)
        }

        if let shareImage = image {
            shareArray.append(shareImage)
        }

        if shareArray.count == 0 {
            return
        }

        let objectsToShare = shareArray
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

        activityVC.excludedActivityTypes = [.airDrop, .assignToContact, .copyToPasteboard, .postToTwitter]
//        activityVC.popoverPresentationController?.sourceView =
        guard let topVC = UIApplication.topViewController() else {
            return
        }
        topVC.present(activityVC, animated: true, completion: nil)
    }
}
