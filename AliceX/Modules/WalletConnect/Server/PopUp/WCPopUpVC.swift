//
//  WCPopUpVC.swift
//  AliceX
//
//  Created by lmcmz on 3/3/20.
//  Copyright © 2020 lmcmz. All rights reserved.
//

import BonMot
import UIKit

class WCPopUpVC: UIViewController {
    @IBOutlet var logoView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var contentView: UITextView!
    @IBOutlet var titleLabel: UILabel!

    var comfirmBlock: VoidBlock?
    var cancelBlock: VoidBlock?

    class func make(logo: URL?, name: String, title: String, content: String, comfirmBlock: VoidBlock?, cancelBlock: VoidBlock?) -> WCPopUpVC {
        let vc = WCPopUpVC()
        vc.configure(logo: logo, name: name, title: title, content: content)
        vc.comfirmBlock = comfirmBlock
        vc.cancelBlock = cancelBlock
        return vc
    }

    func configure(logo: URL?, name: String, title: String, content: String) {
        view.layoutIfNeeded()
        view.roundCorners(corners: [.topLeft, .topRight], radius: 20)

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
        dismiss(animated: true, completion: {
            block!()
        })
    }

    @IBAction func cancelButtonClick() {
        guard let block = cancelBlock else {
            return
        }
        dismiss(animated: true, completion: {
            block!()
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
