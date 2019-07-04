//
//  NetworkTableViewCell.swift
//  AliceX
//
//  Created by lmcmz on 4/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit

class NetworkTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var selectLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectLabel.isHidden = !selected
    }
    
    func configure(network: String) {
//        if network.lowercased() == Web3Net.currentNetwork.rawValue {
//            selectLabel.isHidden = false
//            isSelected = true
//        }
        nameLabel.text = network
    }
}
