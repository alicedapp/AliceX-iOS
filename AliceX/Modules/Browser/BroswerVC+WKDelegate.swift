//
//  BroswerVC+WKDelegate.swift
//  AliceX
//
//  Created by lmcmz on 17/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import Kingfisher
import WebKit

extension BrowserViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation _: WKNavigation!) {
        UIView.animate(withDuration: 0.3, animations: {
            self.navBarContainer.transform = CGAffineTransform.identity
        })
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

        if let wrapper = self.wrapper, let item = wrapper.pinItem() {
            PinManager.shared.updatePinItem(item: item)
        }

        UIView.animate(withDuration: 0.3, animations: {
            self.navBarContainer.transform = CGAffineTransform.identity
            self.progressView.alpha = 0
        }) { _ in
            self.progressView.transform = CGAffineTransform.identity
            self.progressView.alpha = 1

            if self.forceHide {
                self.forceHideBar()
            }
        }
    }
}

extension BrowserViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if translation.y >= 0 {
            if forceHide {
                return
            }

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
