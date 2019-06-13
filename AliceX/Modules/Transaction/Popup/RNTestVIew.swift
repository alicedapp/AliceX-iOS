//
//  RNTestVIew.swift
//  AliceX
//
//  Created by lmcmz on 13/6/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit

class RNTestVIew: UIView {
    
    class func instanceFromNib() -> RNTestVIew {
        let view = UINib(nibName: self.nameOfClass, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! RNTestVIew
        return view
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let rnView = RCTRootView(bridge: AppDelegate.rnBridge(), moduleName: "", initialProperties: nil)
        rnView?.frame = self.bounds
        addSubview(rnView!)
    }

}
