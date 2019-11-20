//
//  BaseRNViewController.swift
//  AliceX
//
//  Created by lmcmz on 1/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit

class BaseRNViewController: BaseViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hero.isEnabled = true
    }
}

extension BaseRNViewController: PinDelegate {
    func pinItem() -> PinItem {
        var url = URL(string: "https://cdn4.iconfinder.com/data/icons/hosting-and-server/500/Hosting-30-512.png")!

//        if let urlStr = vc.webview.url, let hostURL = urlStr.host {
//            url = URL(string: "\(hostURL.addHttpPrefix())/favicon.ico")!
//        }
        return .dapplet(image: url, url: url, title: "Dapp", viewcontroller: self)
    }
}
