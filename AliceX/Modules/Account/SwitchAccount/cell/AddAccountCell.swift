//
//  Add Account Cell.swift
//  AliceX
//
//  Created by lmcmz on 7/1/20.
//  Copyright © 2020 lmcmz. All rights reserved.
//

import UIKit

class AddAccountCell: UITableViewCell {
    var block: VoidBlock!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func createAccountClick() {
        WalletManager.createAccount()
        block!()
    }
}
