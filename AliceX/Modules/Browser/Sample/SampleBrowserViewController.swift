//
//  SampleBrowserViewController.swift
//  AliceX
//
//  Created by lmcmz on 28/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit
import WebKit

class SampleBrowserViewController: BaseViewController {

    @IBOutlet var webView: WKWebView!
    @IBOutlet var titleLabel: UILabel!

    var url: URL = URL(string: "https://www.alicedapp.com")!
    var headerTitle: String?
    
    class func make(url: URL, title: String?) -> SampleBrowserViewController {
        let vc = SampleBrowserViewController()
        vc.url = url
        vc.headerTitle = title
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = URLRequest(url: url)
        webView.load(request)
        titleLabel.text = headerTitle
    }
}

extension SampleBrowserViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if headerTitle == nil {
            titleLabel.text = webView.title
        }
    }
}
