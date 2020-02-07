//
//  AssetTXCell.swift
//  AliceX
//
//  Created by lmcmz on 6/2/20.
//  Copyright © 2020 lmcmz. All rights reserved.
//

import UIKit
import Kingfisher
import VBFPopFlatButton
import BigInt
import web3swift

class AssetTXCell: UITableViewCell {
    
    @IBOutlet var logoView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var hashLabel: UILabel!
    
    @IBOutlet var addressLabel: UILabel!
    
    @IBOutlet var statusButton: VBFPopFlatButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        statusButton.roundBackgroundColor = AliceColor.darkGrey()
        statusButton.currentButtonStyle = .buttonRoundedStyle
        statusButton.currentButtonType = .buttonMinusType
        statusButton.tintColor = AliceColor.darkGrey()
        statusButton.lineRadius = 3
        statusButton.lineThickness = 3
        statusButton.backgroundColor = .clear
        statusButton.roundBackgroundColor = .clear
//        statusButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 4))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configure(model: AmberdataTXModel) {
        
        guard let toList = model.to, let to = toList.first, let fromList = model.from, let from = fromList.first else {
            return
        }
        
        if to.address.lowercased() == WalletManager.currentAccount!.address.lowercased() {
            titleLabel.text = "Received"
            addressLabel.text = from.address
            statusButton.currentButtonType = .buttonDownBasicType
            statusButton.tintColor = AliceColor.green
            
            let amountInt = BigUInt(model.value!)
            let amount = amountInt!.formatToPrecision(decimals: 18)!.round(decimal: 3)
            amountLabel.text = "+ \(String(describing: amount))"
            amountLabel.textColor = AliceColor.green
            
            if let name = from.nameNormalized {
                addressLabel.text = name
            }
            
        } else {
            titleLabel.text = "Sent"
            addressLabel.text = to.address
            statusButton.currentButtonType = .buttonUpBasicType
            statusButton.tintColor = AliceColor.red
            
            let amountInt = BigUInt(model.value!)
            let amount = amountInt!.formatToPrecision(decimals: 18)!.round(decimal: 3)
            
            amountLabel.text = "- \(String(describing: amount))"
            amountLabel.textColor = AliceColor.red
            
            if let name = to.nameNormalized {
                addressLabel.text = name
            }
        }
        
        logoView.image = nil
        
        if let icon = to.icon {
            logoView.kf.setImage(with: URL(string: icon)!)
        }
        
        if let icon = from.icon {
            logoView.kf.setImage(with: URL(string: icon)!)
        }
        
        if let date = model.timestamp {
            let time = Date.getTimeComponentString(olderDate: date, newerDate: Date())
            hashLabel.text = "\(time ?? "unknow") ago"
        }
    }
}
