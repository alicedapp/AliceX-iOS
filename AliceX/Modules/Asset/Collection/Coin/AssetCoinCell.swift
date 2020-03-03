//
//  AssetCoinCell.swift
//  AliceX
//
//  Created by lmcmz on 27/10/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import BigInt
import BonMot
import Kingfisher
import PromiseKit
import UIKit
import VBFPopFlatButton
import web3swift

class AssetCoinCell: UICollectionViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var precentageLabel: UILabel!

    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var balanceLabel: UILabel!

    @IBOutlet var typeLabel: UILabel!

    @IBOutlet var background: UIView!
    @IBOutlet var coinShadow: UIView!
    @IBOutlet var coinImageView: UIImageView!
    @IBOutlet var animationButton: VBFPopFlatButton!

    var coin: Coin = Coin.coin(chain: .Ethereum)

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        let shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: coinShadow.bounds, cornerRadius: 25).cgPath
        shadowLayer.fillColor = UIColor.white.cgColor
        shadowLayer.shadowColor = UIColor(hex: "#000000", alpha: 0.5).cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0, height: 1.0)
        shadowLayer.shadowOpacity = 0.3
        shadowLayer.shadowRadius = 5
        coinShadow.layer.insertSublayer(shadowLayer, at: 1)

        animationButton.currentButtonType = .buttonMinusType
        animationButton.currentButtonStyle = .buttonRoundedStyle
        animationButton.lineThickness = 2
        animationButton.lineRadius = 5
        animationButton.tintColor = UIColor(hex: "9A9A9A", alpha: 0.5)

        // TODO:
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress(gesture:)))
//        longPress.minimumPressDuration = 0
        addGestureRecognizer(longPress)

        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        addGestureRecognizer(tap)

        isHeroEnabled = true
        isHeroEnabledForSubviews = true
    }

    @objc func tapAction(gesture _: UITapGestureRecognizer) {
//        || coin == Coin.coin(chain: .Cosmos)

        let vc = AssetDetailViewController()
        vc.currentCoin = coin
        let topVC = UIApplication.topViewController()
        topVC?.navigationController?.pushViewController(vc, animated: true)

//        switch gesture.state {
//        case .began:
//            UIView.animate(withDuration: 0.3) {
//                self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
//                self.background.alpha = 1
//            }
//
//        case .ended:
//            UIImpactFeedbackGenerator(style: .light).impactOccurred()
//            let vc = TransferPopUp.make(address: "", coin: coin)
//            vc.modalPresentationStyle = .overCurrentContext
//            UIApplication.topViewController()?.present(vc, animated: false, completion: nil)
//            UIView.animate(withDuration: 0.3) {
//                self.transform = CGAffineTransform.identity
//                self.background.alpha = 0
//            }
//
//        default:
//            break
//        }
    }

    @objc func longPress(gesture: UILongPressGestureRecognizer) {
        if coin == Coin.coin(chain: .Bitcoin) {
            HUDManager.shared.showError(text: "Not available now")
            return
        }

        switch gesture.state {
        case .began:
            UIView.animate(withDuration: 0.3) {
                self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                self.background.alpha = 1
            }

            let vc = TransferPopUp.make(address: "", coin: coin)
            vc.modalPresentationStyle = .overCurrentContext
            UIApplication.topViewController()?.present(vc, animated: false, completion: nil)
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()

        case .ended:
            UIView.animate(withDuration: 0.3) {
                self.transform = CGAffineTransform.identity
                self.background.alpha = 0
            }
        default:
            break
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    func configure(coin: Coin, isHidden: Bool) {
        self.coin = coin

        coinImageView.heroID = coin.id

        nameLabel.text = ""
        coinImageView.image = nil
        amountLabel.text = ""
        priceLabel.text = coin.type
        balanceLabel.text = ""
        precentageLabel.text = ""
        animationButton.isHidden = true
        typeLabel.text = coin.type

        coinImageView.kf.setImage(with: coin.image) { result in
            switch result {
            case .success:
                self.typeLabel.isHidden = true
            case .failure:
                self.typeLabel.isHidden = false
            }
        }

        guard let info = coin.info else {
            return
        }

        nameLabel.text = info.name

        if coin == Coin.coin(chain: .Ethereum), WalletManager.currentNetwork != .main {
            let network = WalletManager.currentNetwork

            let nameStyle = StringStyle(
                .font(UIFont.systemFont(ofSize: 17, weight: .regular))
            )
            let networkStyle = StringStyle(
                .color(network.color),
                .font(UIFont.systemFont(ofSize: 12, weight: .bold))
            )

            let finalStyle = StringStyle(
                .font(UIFont.systemFont(ofSize: 17)),
                .xmlRules([
                    .style("name", nameStyle),
                    .style("network", networkStyle),
                ])
            )
            let text = "<name>Ethereum</name> <network>\(network.name)</network>".styled(with: finalStyle)
            nameLabel.attributedText = text
        }

        let currencySymbol = PriceHelper.shared.currentCurrency.symbol

        if let price = info.price {
            priceLabel.text = "\(currencySymbol) \(price.toString(decimal: 3))"
        }

        if let balance = info.amount, let balanceInt = BigUInt(balance),
            let amount = Web3.Utils.formatToPrecision(balanceInt, numberDecimals: info.decimals, formattingDecimals: 4, decimalSeparator: ".", fallbackToScientific: false), let amountInDouble = Double(amount) {
            let removeZero = String(format: "%g", amountInDouble)
            amountLabel.text = "\(removeZero) \(info.symbol!)"

            if let price = info.price, let doubleAmount = Double(amount) {
                balanceLabel.text = "\(currencySymbol) \((doubleAmount * price).toString(decimal: 3))"
            }
        } else {
            amountLabel.text = "0 \(info.symbol!)"
            balanceLabel.text = "\(currencySymbol) 0"
        }

        if let change = info.changeIn24HPercentage {
            animationButton.isHidden = false
            if change > 0.0 {
                animationButton.currentButtonType = .buttonUpBasicType
                animationButton.tintColor = AliceColor.green
                precentageLabel.textColor = UIColor.systemGreen
                let precentage = change.toString(decimal: 2)
                if precentage != "0" {
                    precentageLabel.text = "+\(precentage)%"
                } else {
                    precentageLabel.text = ""
                }

            } else {
                animationButton.currentButtonType = .buttonDownBasicType
                animationButton.tintColor = AliceColor.red
                precentageLabel.textColor = AliceColor.red
                let precentage = change.toString(decimal: 2)
                if precentage != "-0" {
                    precentageLabel.text = "\(precentage)%"
                } else {
                    precentageLabel.text = ""
                }
            }
        }

        if isHidden {
            balanceLabel.text = "**"
            amountLabel.text = "** \(info.symbol!)"
        }
    }
}
