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

    @IBOutlet var networkImage: UIImageView!
    @IBOutlet var networkLabel: UILabel!

    override class func instanceFromNib() -> BrowserPanelView {
        let view = UINib(nibName: nameOfClass, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! BrowserPanelView
        view.configure()
        return view
    }

    override func configure() {
        if WalletManager.currentNetwork != .main {
            let newImage = networkImage.image?.filled(with: WalletManager.currentNetwork.color)
            networkImage.image = newImage
            networkLabel.textColor = WalletManager.currentNetwork.color
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    @IBAction func safariButton() {
        UIApplication.shared.open((vcRef?.webview.url)!)
    }

    @IBAction func favoriteButton() {
        guard let url = vcRef?.webview.url else {
            return
        }

        let item = HomeItem.web(url: url)
        HomeItemHelper.shared.add(item: item)
        HUDManager.shared.showSuccess(text: "Added to screen")
    }

    @IBAction func shareButton() {
        HUDManager.shared.dismiss()
        ShareHelper.share(text: vcRef?.webview.url?.absoluteString, image: nil, urlString: vcRef?.webview.url?.absoluteString)
    }

    @IBAction func pinButton() {
        guard let ref = self.vcRef, let wrapper = ref.wrapper, let item = wrapper.pinItem() else {
            return
        }
        HUDManager.shared.dismiss()
        PinManager.shared.addPinItem(item: item)
        PinManager.shared.currentPin = item
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
        HUDManager.shared.showAlertVCNoBackground(viewController: vc, haveBG: true)
    }

    @IBAction func configureButton() {
//        HUDManager.shared.dismiss()
        let vc = BrowserSettingViewController()
        vc.vcRef = vcRef
        HUDManager.shared.showAlertVCNoBackground(viewController: vc, haveBG: true)

//        vc.modalPresentationStyle = .overCurrentContext
//        vcRef?.present(vc, animated: true, completion: nil)
//        HUDManager.shared.showAlertVCNoBackground(viewController: vc)
    }

    @IBAction func networkButton() {
        HUDManager.shared.dismiss()

//        if #available(iOS 13.0, *) {
//            let vc = NetworkSwitchViewController()
//            vcRef!.present(vc, animated: true, completion: nil)
//            return
//        }

        let vc = NetworkSwitchViewController()
        let topVC = UIApplication.topViewController()
        topVC?.presentAsStork(vc, height: nil, showIndicator: false, showCloseButton: false)
    }
}
