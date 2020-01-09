//
//  HomeWebBrowserVC.swift
//  AliceX
//
//  Created by lmcmz on 22/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Kingfisher
import UIKit

class HomeWebBrowserWrapper: BrowserWrapperViewController {
    override class func make(urlString: String) -> HomeWebBrowserWrapper {
        let vc = HomeWebBrowserWrapper()
        vc.urlString = urlString
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func addBrowser() {
        vc = HomeWebBrowserVC()
        vc.urlString = urlString
        vc.wrapper = self
        vc.willMove(toParent: self)
        vc.view.frame = view.bounds
        view.addSubview(vc.view)
        addChild(vc)
        vc.didMove(toParent: self)
    }
}

class HomeWebBrowserVC: BrowserViewController {
    @IBOutlet var logoImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel = UILabel()

        let url = URL(string: urlString)!
        guard let domain = url.host else {
            return
        }

        ImageCache.default.retrieveImage(forKey: domain) { result in
            onMainThread {
                switch result {
                case let .success(respone):
                    if let image = respone.image {
                        self.logoImage.image = image
                        return
                    }
                    self.logoImage.kf.setImage(with: FaviconHelper.bestIcon(domain: domain))
                case .failure:
                    self.logoImage.kf.setImage(with: FaviconHelper.bestIcon(domain: domain))
                }
            }
        }
    }

    @IBAction func logoClicked() {
        guard let wrapper = self.wrapper, let item = wrapper.pinItem() else {
            return
        }
        PinManager.shared.addPinItem(item: item)
        PinManager.shared.currentPin = wrapper.pinItem()
        wrapper.navigationController?.popViewController(animated: true)
    }

    override func moreButton() {
        let view = HomeWebPanelView.instanceFromNib()
        view.vcRef = self
        HUDManager.shared.showAlertView(view: view, backgroundColor: .clear)
    }
}
