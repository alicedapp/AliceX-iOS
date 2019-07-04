//
//  MnemonicsView.swift
//  AliceX
//
//  Created by lmcmz on 3/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit

class MnemonicsView: UIView {
    
//    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var secretView: UITextField!
    
    class func instanceFromNib() -> MnemonicsView {
        let view = UINib(nibName: self.nameOfClass, bundle: nil)
            .instantiate(withOwner: nil, options: nil)[0] as! MnemonicsView
//        view.comfirmBlock = comfirmBlock
//        view.cancelBlock = cancelBlock
//        view.titleLabel.text = title
        return view
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.roundCorners([.topLeft, .topRight], radius: 10)
        let mnemonics = KeychainHepler.fetchKeychain(key: Setting.MnemonicsKey)
        secretView.text = mnemonics
    }
    
    @IBAction func showClicked() {
        secretView.isSecureTextEntry = !secretView.isSecureTextEntry
    }
    
}
