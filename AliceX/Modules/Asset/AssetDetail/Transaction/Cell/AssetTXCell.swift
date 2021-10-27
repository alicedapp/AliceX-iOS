//
//  AssetTXCell.swift
//  AliceX
//
//  Created by lmcmz on 6/2/20.
//  Copyright © 2020 lmcmz. All rights reserved.
//

import BigInt
import Kingfisher
import UIKit
import VBFPopFlatButton
import web3swift

class AssetTXCell: UITableViewCell {
    @IBOutlet var logoView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var hashLabel: UILabel!

    @IBOutlet var addressLabel: UILabel!

    @IBOutlet var statusButton: VBFPopFlatButton!

    //    var coin: Coin = .coin(chain: .Ethereum)

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

    func configure(model: AmberdataTXModel, coin: Coin) {
        guard let toList = model.to, let to = toList.first, let fromList = model.from, let from = fromList.first else {
            return
        }

        logoView.image = nil

        var currentAddress = WalletManager.currentAccount!.address.lowercased()
        let walletList = WalletManager.Accounts!.map { $0.address.lowercased() }

        if coin.blockchain == .Binance || coin.blockchain == .Bitcoin {
            currentAddress = WalletCore.address(blockchain: coin.blockchain)
        }

        if to.address.lowercased() == currentAddress {
            titleLabel.text = "Received"
            if let statusResult = model.statusResult, !statusResult.success {
                titleLabel.text = "Received ❌"
            }
            addressLabel.text = from.address
            statusButton.currentButtonType = .buttonDownBasicType
            statusButton.tintColor = AliceColor.green

            let amountInt = BigUInt(model.value!)
            let amount = amountInt!.formatToPrecision(decimals: coin.info!.decimals)!.round(decimal: 3)
            amountLabel.text = "+ \(String(describing: amount)) \(coin.info!.symbol ?? "")"
            amountLabel.textColor = AliceColor.green

            if let name = from.nameNormalized {
                addressLabel.text = name
            }

            if let index = walletList.firstIndex(of: from.address) {
                let wallet = WalletManager.Accounts![index]
                addressLabel.text = wallet.name
                logoView.image = UIImage(named: wallet.imageName)
            }

        } else {
            titleLabel.text = "Sent"
            if let statusResult = model.statusResult, !statusResult.success {
                titleLabel.text = "Sent ❌"
            }

            addressLabel.text = to.address
            statusButton.currentButtonType = .buttonUpBasicType
            statusButton.tintColor = AliceColor.red

            let amountInt = BigUInt(model.value!)
            let amount = amountInt!.formatToPrecision(decimals: coin.info!.decimals)!.round(decimal: 3)

            amountLabel.text = "- \(String(describing: amount)) \(coin.info!.symbol ?? "")"
            amountLabel.textColor = AliceColor.red

            if let name = to.nameNormalized {
                addressLabel.text = name
            }

            if let index = walletList.firstIndex(of: to.address) {
                let wallet = WalletManager.Accounts![index]
                addressLabel.text = wallet.name
                logoView.image = UIImage(named: wallet.imageName)
            }
        }

        if to.address.lowercased() == currentAddress,
           from.address.lowercased() == currentAddress {
            logoView.image = UIImage(named: WalletManager.currentAccount!.imageName)
            addressLabel.text = "Self"
        }

        if let icon = to.icon {
            logoView.kf.setImage(with: URL(string: icon)!)
        }

        if let icon = from.icon {
            logoView.kf.setImage(with: URL(string: icon)!)
        }

        if let transfers = model.tokenTransfers, let transfer = transfers.last {
            addressLabel.text = transfer.name
        }

        if let date = model.timestamp {
            //            let time = Date.getTimeComponentString(olderDate: date, newerDate: Date())

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy 'at' HH:mm"
            hashLabel.text = dateFormatter.string(from: date)
            //            "\(time ?? "unknow") ago"
        }

        if coin.isERC20, let transfers = model.tokenTransfers, let transfer = transfers.last {
            let amountInt = BigUInt(transfer.amount)
            let amount = amountInt!.formatToPrecision(decimals: Int(transfer.decimals)!)!.round(decimal: 3)

            if amountLabel.textColor == AliceColor.green {
                amountLabel.text = "+ \(String(describing: amount)) \(coin.info!.symbol ?? "")"
            } else {
                amountLabel.text = "- \(String(describing: amount)) \(coin.info!.symbol ?? "")"
            }
        }
    }
}
