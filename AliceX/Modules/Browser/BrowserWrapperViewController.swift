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
class BrowserWrapperViewController: BaseViewController, UIGestureRecognizerDelegate {
    var vc: BrowserViewController!
    var urlString: String = ""
    //    @objc var hk_iconImage: UIImage = UIImage.imageWithColor(color: UIColor(hex: "D5D5D5"))

    private var observer: NSObjectProtocol?

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

        //        setNeedsUpdateOfHomeIndicatorAutoHidden()
        //        setNeedsUpdateOfScreenEdgesDeferringSystemGestures()
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

        //        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(swipeUp))
        //        gesture.edges = .bottom
        //        gesture.delegate = self
        //        self.view.addGestureRecognizer(gesture)
        //
        ////        setNeedsUpdateOfScreenEdgesDeferringSystemGestures()
        //
        //        observer = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { [unowned self] notification in
        //            self.setNeedsUpdateOfScreenEdgesDeferringSystemGestures()
        //        }
    }

    //    @objc func swipeUp(_ recognizer: UIScreenEdgePanGestureRecognizer) {
    //        //TODO: Force show
    //
    //        if recognizer.state == .recognized {
    //            print("Screen edge swiped!")
    //        }
    //
    //        print("DDDDDD")
    ////        vc.forceShowBar()
    //        vc.forceHide = false
    //    }

    deinit {
        NotificationCenter.default.removeObserver(self)

        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
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
        guard let url = vc.webview.url else {
            return
        }
        urlString = url.absoluteString
        vc.willMove(toParent: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParent()
        addBrowser()
    }

    //    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
    //        return .bottom
    //    }

    //    override var childForScreenEdgesDeferringSystemGestures: UIViewController? {
    //        return vc
    //    }
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
