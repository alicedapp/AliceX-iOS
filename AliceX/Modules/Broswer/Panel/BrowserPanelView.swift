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
        let view = UINib(nibName: self.nameOfClass, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! BrowserPanelView
        view.configure()
        return view
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @IBAction func safariButton() {
        UIApplication.shared.open((vcRef?.webview.url)!)
    }
    
    @IBAction func shareButton() {
        
    }
    
    @IBAction func dappButton() {
        let vc = DAppListViewController()
        vc.vcRef = vcRef
        HUDManager.shared.showAlertVCNoBackground(viewController: vc)
    }
    
    @IBAction func networkButton() {
        HUDManager.shared.dismiss()
        let vc = NetworkSwitchViewController()
        let topVC = UIApplication.topViewController()
        topVC?.presentAsStork(vc, height: nil, showIndicator: false, showCloseButton: false)
    }
}
