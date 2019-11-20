//
//  BaseRNAppViewController.swift
//  AliceX
//
//  Created by lmcmz on 21/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation

class BaseRNAppViewController: BaseViewController {
    
    var item: HomeItem?
    
    class func make(item: HomeItem) -> BaseRNAppViewController {
        let vc = BaseRNAppViewController()
        vc.item = item
        return vc
    }
    
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

extension BaseRNAppViewController: PinDelegate {
    func pinItem() -> PinItem {

        guard let item = self.item, item.isApp else {
//            let url =
            return .dapplet(image: URL(string: "https://alicedapp.com")!, url: URL(string: "https://alicedapp.com")!, title: "Dapp", viewcontroller: self)
        }
        
//        if let urlStr = vc.webview.url, let hostURL = urlStr.host {
//            url = URL(string: "\(hostURL.addHttpPrefix())/favicon.ico")!
//        }
        return .dapplet(image: item.appImage!, url: URL(string: "https://alicedapp.com")!, title: item.name, viewcontroller: self)
    }
}
