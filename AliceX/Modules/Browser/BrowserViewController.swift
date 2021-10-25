//
//  BrowserViewController.swift
//  AliceX
//
//  Created by lmcmz on 12/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import SwiftyUserDefaults
import UIKit
import WebKit

class BrowserViewController: BaseViewController {
    @IBOutlet var webContainer: UIView!
    @IBOutlet var navBarContainer: UIView!
    @IBOutlet var navBar: UIView!
//    @IBOutlet weak var navBarShadowView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var progressView: UIView!

    @IBOutlet var refreshImage: UIImageView!
    @IBOutlet var backButtonImage: UIImageView!

    @IBOutlet var panelImage: UIImageView!

    var webview: WKWebView!
    var urlString: String = "https://uniswap.exchange"
//    "https://app.compound.finance/"
//    "http://www.google.com"

    var forceHide: Bool = false {
        didSet {
            if self.forceHide {
                forceHideBar()
            } else {
                forceShowBar()
            }
        }
    }

    weak var wrapper: BrowserWrapperViewController?

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()

        navigationController?.navigationBar.barStyle = .default

        let scriptConfig = ETHWeb3ScriptWKConfig(address: WalletManager.currentAccount!.address,
                                                 chainId: WalletManager.currentNetwork.chainID,
                                                 rpcUrl: WalletManager.currentNetwork.rpcURL.absoluteString,
                                                 privacyMode: false)

        let config = WKWebViewConfiguration()
        config.websiteDataStore = WKWebsiteDataStore.default()
        let controller = WKUserContentController()
        controller.addUserScript(scriptConfig.providerScript)
        controller.addUserScript(scriptConfig.injectedScript)
        let proxy = ScriptMessageProxy(delegate: self)
        for name in ETHDAppMethod.allCases {
            controller.add(proxy, name: name.rawValue)
        }
        config.userContentController = controller
        webview = WKWebView(frame: .zero, configuration: config)

        // TODO: Conflict with Pin
//        webview.allowsBackForwardNavigationGestures = true

        navBarContainer.layer.shadowColor = UIColor(hex: "#000000", alpha: 0.2).cgColor
        navBarContainer.layer.shadowOpacity = 0.5
        navBarContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        navBarContainer.layer.shadowRadius = 5

        if WalletManager.currentNetwork != .main {
            let newImage = panelImage.image?.filled(with: WalletManager.currentNetwork.color)
            panelImage.image = newImage

            navBar.layer.borderColor = WalletManager.currentNetwork.color.cgColor
            navBar.layer.borderWidth = 1
        }

        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(navBarSwipe(swipe:)))
        swipeGesture.direction = .down
        navBar.addGestureRecognizer(swipeGesture)

//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(navBarPan(pan:)))
        ////        panGesture.
//        navBar.addGestureRecognizer(panGesture)

        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(swipeUp))
        gesture.edges = .right
        view.addGestureRecognizer(gesture)

        webview.navigationDelegate = self
        webview.scrollView.delegate = self
        webview.frame = CGRect(x: 0, y: 0, width: Constant.SCREEN_WIDTH,
                               height: Constant.SCREEN_HEIGHT - Constant.SAFE_TOP)

        webContainer.addSubview(webview)
        webview.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)

        urlString = EditAddressViewController.makeUrlIfNeeded(urlString: urlString).trimed()
        guard let url = URL(string: urlString) else {
            let defaultEngine = Defaults[\.searchEngine]
            let engine = SearchEngine(rawValue: defaultEngine)!
            let request = URLRequest(url: engine.baseURL)
            webview.load(request)
            return
        }

        let request = URLRequest(url: url)
        webview.load(request)
    }

    @objc func swipeUp(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        // TODO: Force show

        if recognizer.state == .recognized {
            print("Screen edge swiped!")
            forceHide = false
        }

        print("AAAAA")
//        vc.forceShowBar()
    }

    func forceHideBar() {
        UIView.animate(withDuration: 0.3) {
            self.navBarContainer.transform = CGAffineTransform(translationX: 0, y: 94)
        }
    }

    func forceShowBar() {
        UIView.animate(withDuration: 0.3) {
            self.navBarContainer.transform = CGAffineTransform.identity
        }
    }

    @objc func navBarSwipe(swipe _: UISwipeGestureRecognizer) {
        forceHide = true
    }

    @objc func navBarPan(pan _: UIPanGestureRecognizer) {}

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewWillLayoutSubviews() {
        webContainer.layoutIfNeeded()
        webContainer.roundCorners(corners: [.topLeft, .topRight], radius: 20)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleLabel.isHidden = false
    }

    class func cleanCache() {
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                print("[WebCacheCleaner] Record \(record) deleted")
                HUDManager.shared.showSuccess(text: "Cache have been cleaned")
            }
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of _: Any?,
                               change _: [NSKeyValueChangeKey: Any]?,
                               context _: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            let progress = webview.estimatedProgress
            let length = CGFloat(Double(Constant.SCREEN_WIDTH - 40) * progress)
            UIView.animate(withDuration: 0.3, animations: {
                self.progressView.transform = CGAffineTransform(translationX: length, y: 0)
            })
        }
    }

    func goTo(url: URL) {
        webview.load(URLRequest(url: url))
    }

    @IBAction func backButtonClick() {
        if webview.canGoBack {
            webview.goBack()
        } else {
            backButtonClicked()
        }
    }

    @IBAction func moreButton() {
        let view = BrowserPanelView.instanceFromNib()
        view.vcRef = self
        HUDManager.shared.showAlertView(view: view, backgroundColor: .clear)
    }

    @IBAction func refreshButtonClick() {
        UIView.animate(withDuration: 0.3, animations: {
            self.refreshImage.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }) { _ in
            self.refreshImage.transform = CGAffineTransform.identity
        }
        webview.reload()
    }

    @IBAction func closeButtonClick() {
//        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func addressButtonClick() {
        let vc = EditAddressViewController()
        vc.address = webview.url?.absoluteString
        vc.hero.modalAnimationType = .fade
        vc.browerRef = self
//        titleLabel.isHidden = true
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}
