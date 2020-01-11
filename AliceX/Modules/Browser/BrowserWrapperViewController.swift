//
//  BrowserWrapperViewController.swift
//  AliceX
//
//  Created by lmcmz on 23/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

// Wrapper Broswer For Switch Network
class BrowserWrapperViewController: BaseViewController {
    var vc: BrowserViewController!
    var urlString: String = ""
//    @objc var hk_iconImage: UIImage = UIImage.imageWithColor(color: UIColor(hex: "D5D5D5"))

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    class func make(urlString: String) -> BrowserWrapperViewController {
        let vc = BrowserWrapperViewController()
        vc.urlString = urlString
        return vc
    }

    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)
    }

    override func viewDidLoad() {
        if urlString.isEmptyAfterTrim() {
            urlString = Defaults[\.homepage].absoluteString
        }
        addBrowser()
        NotificationCenter.default.addObserver(self, selector: #selector(changeNetwork),
                                               name: .networkChange, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeNetwork),
                                               name: .accountChange, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeNetwork),
                                               name: .walletChange, object: nil)
        
        
        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(swipeUp))
        gesture.edges = .bottom
        self.view.addGestureRecognizer(gesture)
    }
    
    @objc func swipeUp() {
        //TODO: Force show
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func addBrowser() {
        vc = BrowserViewController()
        vc.urlString = urlString
        vc.wrapper = self
        vc.willMove(toParent: self)
        vc.view.frame = view.bounds
        view.addSubview(vc.view)
        addChild(vc)
        vc.didMove(toParent: self)
    }

    @objc func changeNetwork() {
        urlString = vc.webview.url!.absoluteString
        vc.willMove(toParent: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParent()
        addBrowser()
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return false
    }

    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return UIRectEdge.bottom
    }
}

extension BrowserWrapperViewController: PinDelegate {
    func pinItem() -> PinItem? {
        guard let url = vc.webview.url else {
            return nil
        }

        let imageURL = FaviconHelper.bestIcon(url: url)

//        if let urlStr = vc.webview.url, let hostURL = urlStr.host {
//            url = URL(string: "\(hostURL.addHttpPrefix())/favicon.ico")!
//        }

        FaviconHelper.prefetchFavicon(urls: [url])
        return .website(image: imageURL,
                        url: vc.webview.url!,
                        title: vc.webview.title ?? vc.webview.url!.absoluteString,
                        viewcontroller: self)
    }
}
