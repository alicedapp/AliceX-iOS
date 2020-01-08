//
//  MnemonicTableViewCell.swift
//  AliceX
//
//  Created by lmcmz on 8/1/20.
//  Copyright © 2020 lmcmz. All rights reserved.
//

import UIKit
import PromiseKit
import SwiftyUserDefaults

class MnemonicTableViewCell: UITableViewCell {

    @IBOutlet var cellView: BaseControl!
    
    @IBOutlet var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let isBackuped = Defaults[\.MnemonicsBackup]
        cellView.backgroundColor = isBackuped ? AliceColor.lightBackground() : AliceColor.red
        
        titleLabel.text = isBackuped ? "My Mnemonic" : "Backup My Mnemonic"
        titleLabel.textColor = isBackuped ? AliceColor.darkGrey() : .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func mnemonicsClicked() {
        #if DEBUG
//            HUDManager.shared.showAlertView(view: MnemonicsView.instanceFromNib())
            let vc = MnemonicsViewController()
            UIApplication.topViewController()!.navigationController?.pushViewController(vc, animated: true)
        #else
            biometricsVerify()
        #endif
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
