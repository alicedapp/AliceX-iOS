//
//  CurrencyTableViewCell.swift
//  AliceX
//
//  Created by lmcmz on 19/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var selectLabel: UILabel!
    @IBOutlet var flagLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectLabel.isHidden = !selected
    }

    func configure(currency: Currency) {
        flagLabel.text = currency.flag
        nameLabel.text = currency.rawValue
    }
}
