//
//  BaseRNViewController.swift
//  AliceX
//
//  Created by lmcmz on 1/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit

class BaseRNViewController: BaseViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hero.isEnabled = true
    }
}
