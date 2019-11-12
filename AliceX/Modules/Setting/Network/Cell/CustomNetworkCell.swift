//
//  CustomNetworkCell.swift
//  AliceX
//
//  Created by lmcmz on 12/9/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit

class CustomNetworkCell: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var selectLabel: UILabel!
    @IBOutlet var colorView: UIView!

    var net: Web3NetEnum!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectLabel.isHidden = !selected
    }

    func configure(network: Web3NetEnum) {
        //        if network.lowercased() == Web3Net.currentNetwork.rawValue {
        //            selectLabel.isHidden = false
        //            isSelected = true
        //        }
        net = network
        colorView.backgroundColor = network.color
        nameLabel.text = network.name
    }

    @IBAction func editButtonClick() {
        let vc = RPCCustomViewController.make(model: net.model)
        UIApplication.topNavigationController()?.pushViewController(vc, animated: true)
    }
}
