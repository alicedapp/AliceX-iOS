//
//  PinManager+Favicon.swift
//  AliceX
//
//  Created by lmcmz on 22/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation

extension PinManager {
    @objc func updateImage(noti: Notification) {
        guard let info = noti.userInfo, let domain = info["domain"] as? String else {
            return
        }

        let matched = pinList.filter { $0.URL?.host == domain }

        if matched.count == 0 {
            return
        }

        for item in matched {}

//        guard let url = self.pinList, let localDomain = url.host, localDomain == domain else {
//             return
//         }
//
//        ImageCache.default.retrieveImage(forKey: domain) { result in
//         onMainThread {
//            switch result {
//            case let .success(respone):
//                 if let image = respone.image {
//                    self.iconView.image = image
//                     self.emojiLabel.isHidden = true
//                    return
//                }
//                self.emojiLabel.isHidden = false
//                self.emojiLabel.text = Constant.randomEmoji()
//            case .failure:
//                self.emojiLabel.isHidden = false
//                self.emojiLabel.text = Constant.randomEmoji()
//            }
//         }
//        }
    }
}
