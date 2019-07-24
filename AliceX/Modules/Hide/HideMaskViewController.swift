//
//  HideMaskViewController.swift
//  AliceX
//
//  Created by lmcmz on 24/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit

class HideMaskViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.view.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.view.alpha = 1.0
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.view.alpha = 1
        UIView.animate(withDuration: 0.3) {
            self.view.alpha = 0
        }
    }
    
    
}
