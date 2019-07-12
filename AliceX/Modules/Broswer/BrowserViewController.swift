//
//  BrowserViewController.swift
//  AliceX
//
//  Created by lmcmz on 12/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit
import web3swift
import BigInt

class BrowserViewController: BaseViewController {

    @IBOutlet weak var webContainer: UIView!
    @IBOutlet weak var navBarContainer: UIView!
//    @IBOutlet weak var navBarShadowView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var config: WKWebViewConfiguration!
    var webview: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let config = WKWebViewConfiguration.make(forServer: Web3Net.currentNetwork,
                                                 address: WalletManager.wallet!.address,
                                                 in: ScriptMessageProxy(delegate: self))
        config.websiteDataStore = WKWebsiteDataStore.default()
        
//        config.websiteDataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
//            records.forEach { record in
//                config.websiteDataStore.removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
//                print("[WebCacheCleaner] Record \(record) deleted")
//            }
//        }
        
        webview =  WKWebView(frame: .zero, configuration: config)
        webview.allowsBackForwardNavigationGestures = true
        
        navBarContainer.layer.shadowColor = UIColor(hex: "#000000", alpha: 0.2).cgColor
        navBarContainer.layer.shadowOpacity = 0.5
        navBarContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        navBarContainer.layer.shadowRadius = 5
        
        webContainer.roundCorners(corners: [.topLeft, .topRight], radius: 20)
        webview.navigationDelegate = self
        webview.scrollView.delegate = self
        webview.frame = webContainer.bounds
        
//        let url = URL(string: "https://web3app-cbrbkckrtz.now.sh")
        let url = URL(string: "https://www.cryptokitties.co/")
//        let url = URL(string: "https://uniswap.exchange/swap")
        
        let request = URLRequest(url: url!)
        webview.load(request)
        webContainer.addSubview(webview)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleLabel.isHidden = false
    }
    
    func goTo(url: URL) {
        webview.load(URLRequest(url: url))
    }
    
    @IBAction func backButtonClick() {
        if self.webview.canGoBack {
            self.webview.goBack()
        }
    }
    
    @IBAction func forwordButton() {
        if self.webview.canGoForward {
            self.webview.goForward()
        }
    }
    
    @IBAction func refreshButtonClick() {
        self.webview.reload()
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
        self.present(vc, animated: true, completion: nil)
    }
    
    func notifyFinish(callbackID: Int, value: String) {
//        let script: String = {
//            switch value {
////            case .success(let result):
//                return "executeCallback(\(callbackID), null, \"\(result.value.object)\")"
////            case .failure(let error):
//                return "executeCallback(\(callbackID), \"\(error)\", null)"
//            }
//        }()
        
        let script: String = "executeCallback(\(callbackID), null, \"\(value)\")"
        webview.evaluateJavaScript(script, completionHandler: nil)
    }
    
}

extension BrowserViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.titleLabel.text = webview.title
    }
}

extension BrowserViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
//        webview.scrollView.contentOffset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        var offsetY = scrollView.contentOffset.y
        
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if translation.y > 0 {
            UIView.animate(withDuration: 0.3) {
                self.navBarContainer.transform = CGAffineTransform.identity
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.navBarContainer.transform = CGAffineTransform.init(translationX: 0, y: 90)
            }
        }
    }
}

extension BrowserViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let message = message
        print(message.name)
        print("12121211")
        
        switch message.name {
        case Method.signPersonalMessage.rawValue:
            guard var body = message.body as? [String: AnyObject] else { return }
            var object = body["object"] as? [String: AnyObject]
            var dataString = object!["data"] as! String
            TransactionManager.showSignMessageView(message: dataString) { (signData) in
                self.notifyFinish(callbackID: 8888, value: signData)
            }
        case Method.signMessage.rawValue:
            
            print("signMessage")
        case Method.signTransaction.rawValue:
            guard var body = message.body as? [String: AnyObject] else { return }
            var transactionJSON = body["object"] as! [String: Any]
            guard let transaction = EthereumTransaction.fromJSON(transactionJSON) else {return}
            guard let options = TransactionOptions.fromJSON(transactionJSON) else {return}
            var transactionOptions = TransactionOptions()
            transactionOptions.from = options.from
            transactionOptions.to = options.to
            transactionOptions.value = options.value != nil ? options.value! : BigUInt(0)
            
            let realValue = Double(transactionOptions.value!) / Double(pow(Double(10), Double(17)))
            
            TransactionManager.showSignTransactionView(to: options.to!.address,
                                                       value: String(realValue),
                                                       data: "") { (signData) in
                self.notifyFinish(callbackID: 8888, value: signData)
            }
            
            print("signTransaction")
            
        case Method.signTypedMessage.rawValue:
            print("signTypedMessage")
            
        case Method.sendTransaction.rawValue:
            print("sendTransaction")
        default:
            print("Error")
        }
        
        
        
//        guard let command = DappAction.fromMessage(message) else { return }
//        let requester = DAppRequester(title: webView.title, url: webView.url)
//        let token = TokensDataStore.token(forServer: server)
//        let transfer = Transfer(server: server, type: .dapp(token, requester))
//        let action = DappAction.fromCommand(command, transfer: transfer)
//
//        delegate?.didCall(action: action, callbackID: command.id, inBrowserViewController: self)
    }
}
