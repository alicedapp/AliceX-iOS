//
//  MnemonicTableViewCell.swift
//  AliceX
//
//  Created by lmcmz on 8/1/20.
//  Copyright © 2020 lmcmz. All rights reserved.
//

import PromiseKit
import SwiftyUserDefaults
import UIKit

class MnemonicTableViewCell: UITableViewCell {
    @IBOutlet var cellView: BaseControl!

    @IBOutlet var titleLabel: UILabel!

    @IBOutlet var firstImage: UIImageView!
    @IBOutlet var secondImage: UIImageView!

    var isMnemonic: Bool = true

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(isMnemonic: Bool) {
        self.isMnemonic = isMnemonic

        if isMnemonic {
            let isBackuped = Defaults[\.MnemonicsBackup]
            cellView.backgroundColor = isBackuped ? AliceColor.lightBackground() : AliceColor.red

            titleLabel.text = isBackuped ? "My Mnemonic" : "Backup My Mnemonic"
            titleLabel.textColor = isBackuped ? AliceColor.darkGrey() : .white

            firstImage.image = UIImage(named: "mnemonics-setting")
            secondImage.image = UIImage(named: "mnemonics-setting")

            return
        }

        titleLabel.text = "Replace Wallet"
        titleLabel.textColor = AliceColor.darkGrey()

        firstImage.image = UIImage(named: "replace-wallet-setting")
        secondImage.image = UIImage(named: "replace-wallet-setting")
        cellView.backgroundColor = AliceColor.lightBackground()
    }

    @IBAction func mnemonicsClicked() {
        if isMnemonic {
            #if DEBUG
                //            HUDManager.shared.showAlertView(view: MnemonicsView.instanceFromNib())
                let vc = MnemonicsViewController()
                UIApplication.topViewController()!.navigationController?.pushViewController(vc, animated: true)
            #else
                biometricsVerify()
            #endif

            return
        }

        let vc = ImportWalletViewController.make(buttonText: "Replace Wallet", mnemonic: "")
        UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
    }

    func biometricsVerify() {
        firstly {
            FaceIDHelper.shared.faceID()
        }.done { _ in
            let vc = MnemonicsViewController()
            UIApplication.topViewController()!.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
