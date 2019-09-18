//
//  BrowserPanelView.swift
//  AliceX
//
//  Created by lmcmz on 14/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit

class BrowserPanelView: BaseView {
    weak var vcRef: BrowserViewController?

    override class func instanceFromNib() -> BrowserPanelView {
        let view = UINib(nibName: nameOfClass, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! BrowserPanelView
        view.configure()
        return view
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    @IBAction func safariButton() {
        UIApplication.shared.open((vcRef?.webview.url)!)
    }

    @IBAction func shareButton() {}
    
    @IBAction func pinButton() {
        guard let ref = self.vcRef, let wrapper = ref.wrapper else {
            return
        }
        HUDManager.shared.dismiss()
        PinManager.shared.addPinItem(item: wrapper.pinItem())
        PinManager.shared.currentPin = wrapper.pinItem()
        wrapper.navigationController?.popViewController(animated: true)
    }

    @IBAction func forwardButton() {
        if vcRef!.webview.canGoForward {
            vcRef?.webview.goForward()
        }
    }

    @IBAction func dappButton() {
        let vc = DAppListViewController()
        vc.vcRef = vcRef
        HUDManager.shared.showAlertVCNoBackground(viewController: vc)
    }

    @IBAction func networkButton() {
        HUDManager.shared.dismiss()

        if #available(iOS 13.0, *) {
            let vc = NetworkSwitchViewController()
            vcRef!.present(vc, animated: true, completion: nil)
            return
        }

        let vc = NetworkSwitchViewController()
        let topVC = UIApplication.topViewController()
        topVC?.presentAsStork(vc, height: nil, showIndicator: false, showCloseButton: false)
    }
}
