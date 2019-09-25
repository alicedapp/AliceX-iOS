//
//  WCPopUp.swift
//  AliceX
//
//  Created by lmcmz on 24/9/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit
import BonMot

class WCPopUp: UIView {
    
    @IBOutlet var logoView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var contentView: UITextView!
    @IBOutlet var titleLabel: UILabel!
    
    var comfirmBlock: VoidBlock?
    var cancelBlock: VoidBlock?
    
    class func make(logo: URL?, name: String, title: String, content: String, comfirmBlock: VoidBlock?, cancelBlock: VoidBlock?) -> WCPopUp {
        let view = UINib(nibName: nameOfClass, bundle: nil).instantiate(withOwner: nil, options: nil).first as! WCPopUp
        view.configure(logo: logo, name: name, title: title, content: content)
        view.comfirmBlock = comfirmBlock
        view.cancelBlock = cancelBlock
        return view
    }
    
    override func awakeFromNib() {
        roundCorners(corners: [.topLeft, .topRight], radius: 20)
    }
    
    func configure(logo: URL?, name: String, title: String, content: String) {
        titleLabel.text = title
        nameLabel.text = name
        logoView.kf.setImage(with: logo, placeholder: Constant.placeholder)
        
        let aliceStyle = StringStyle(
//            .font(UIFont(name: "PlayfairDisplay-Black", size: 17)!)
            .font(UIFont.systemFont(ofSize: 17))
        )
        
        let redStyle = StringStyle(
            .color(AliceColor.red),
            .font(UIFont.systemFont(ofSize: 17, weight: .semibold))
        )
        let blueStyle = StringStyle(
            .color(AliceColor.blue),
            .font(UIFont.systemFont(ofSize: 17, weight: .bold))
        )

        let fishStyle = StringStyle(
            .font(UIFont.systemFont(ofSize: 17)),
            .lineHeightMultiple(1.2),
            .color(.darkGray),
            .xmlRules([
                .style("alice", aliceStyle),
                .style("red", redStyle),
                .style("blue", blueStyle),
                ])
        )

        let attributedString = content.styled(with: fishStyle)
        contentView.attributedText = attributedString
    }
    
    @IBAction func comfirmButtonClick() {
        guard let block = comfirmBlock else {
            return
        }
        block!()
        HUDManager.shared.dismiss()
    }
    
    @IBAction func cancelButtonClick() {
        guard let block = cancelBlock else {
            return
        }
        block!()
        HUDManager.shared.dismiss()
    }
}
