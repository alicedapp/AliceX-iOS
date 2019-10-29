//
//  BroswerVC+WKDelegate.swift
//  AliceX
//
//  Created by lmcmz on 17/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import Kingfisher

extension BrowserViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation _: WKNavigation!) {
        UIView.animate(withDuration: 0.3, animations: {
            self.navBarContainer.transform = CGAffineTransform.identity
        })

        guard let hostURL = webView.url?.host else {
            return
        }

        let favIcon = URL(string: "\(hostURL.addHttpPrefix())/favicon.ico")!
        let downloader = ImageDownloader.default
        downloader.downloadImage(with: favIcon) { result in
            switch result {
            case let .success(value):
                self.hk_iconImage = value.image
            case .failure:
                self.hk_iconImage = UIImage.imageWithColor(color: UIColor(hex: "D5D5D5"))
            }
        }
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated {
            guard let url = navigationAction.request.url else { return }
            webView.load(URLRequest(url: url))
        }
        decisionHandler(.allow)
    }

    func webView(_: WKWebView, didFinish _: WKNavigation!) {
        titleLabel.text = webview.title

        backButtonImage.isHighlighted = webview.canGoBack

        PinManager.shared.updatePinItem(item: (wrapper?.pinItem())!)

        UIView.animate(withDuration: 0.3, animations: {
            self.navBarContainer.transform = CGAffineTransform.identity
            self.progressView.alpha = 0
        }) { _ in
            self.progressView.transform = CGAffineTransform.identity
            self.progressView.alpha = 1
        }
    }
}

extension BrowserViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if translation.y > 0 {
            UIView.animate(withDuration: 0.3) {
                self.navBarContainer.transform = CGAffineTransform.identity
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.navBarContainer.transform = CGAffineTransform(translationX: 0, y: 94)
            }
        }
    }
}
