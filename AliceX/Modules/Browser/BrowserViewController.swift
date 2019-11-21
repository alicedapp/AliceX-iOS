//
//  BrowserViewController.swift
//  AliceX
//
//  Created by lmcmz on 12/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit

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

    var config: WKWebViewConfiguration!
    var webview: WKWebView!
    var urlString: String = "https://uniswap.exchange"
//    "https://app.compound.finance/"
//    "http://www.google.com"

    weak var wrapper: BrowserWrapperViewController?

    @objc var hk_iconImage: UIImage? {
        didSet {
            guard let wrapper = self.wrapper else {
             return
            }
            wrapper.hk_iconImage = hk_iconImage ?? UIImage.imageWithColor(color: UIColor(hex: "D5D5D5"))
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()

        navigationController?.navigationBar.barStyle = .default

        config = WKWebViewConfiguration.make(forServer: WalletManager.currentNetwork,
                                             address: WalletManager.wallet!.address,
                                             in: ScriptMessageProxy(delegate: self))
        config.websiteDataStore = WKWebsiteDataStore.default()

        webview = WKWebView(frame: .zero, configuration: config)

        // TODO: Conflict with Pin
//        webview.allowsBackForwardNavigationGestures = true

        navBarContainer.layer.shadowColor = UIColor(hex: "#000000", alpha: 0.2).cgColor
        navBarContainer.layer.shadowOpacity = 0.5
        navBarContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        navBarContainer.layer.shadowRadius = 5

        webview.navigationDelegate = self
        webview.scrollView.delegate = self
        webview.frame = CGRect(x: 0, y: 0, width: Constant.SCREEN_WIDTH,
                               height: Constant.SCREEN_HEIGHT - Constant.SAFE_TOP)

//        let url = URL(string: "https://web3app-cbrbkckrtz.now.sh")
//        let url = URL(string: "https://www.cryptokitties.co/")
//        let url = URL(string: "https://uniswap.exchange/swap")

        urlString = EditAddressViewController.makeUrlIfNeeded(urlString: urlString)
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        webview.load(request)
        webContainer.addSubview(webview)

        webview.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)

        if WalletManager.currentNetwork != .main {
            let newImage = panelImage.image?.filled(with: WalletManager.currentNetwork.color)
            panelImage.image = newImage

            navBar.layer.borderColor = WalletManager.currentNetwork.color.cgColor
            navBar.layer.borderWidth = 1
        }
    }

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
