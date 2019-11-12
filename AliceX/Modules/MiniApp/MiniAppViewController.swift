//
//  MiniAppViewController.swift
//  AliceX
//
//  Created by lmcmz on 12/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit

class MiniAppViewController: BaseViewController {

    @IBOutlet var rnContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let rnView = RCTRootView(bridge: AppDelegate.rnBridge(),
                                       moduleName: AliceRN.alice.rawValue,
                                       initialProperties: nil) else {
                                        return
        }
        rnContainer.addSubview(rnView)
        rnView.fillSuperview()
    }
    
    

}
