//
//  HomeWebPanelView.swift
//  AliceX
//
//  Created by lmcmz on 22/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit

class HomeWebPanelView: BrowserPanelView {
    override class func instanceFromNib() -> HomeWebPanelView {
        let view = UINib(nibName: nameOfClass, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! HomeWebPanelView
        view.configure()
        return view
    }
}
