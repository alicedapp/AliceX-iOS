//
//  AssetCoinCell.swift
//  AliceX
//
//  Created by lmcmz on 27/10/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Kingfisher
import UIKit
import VBFPopFlatButton

class AssetCoinCell: UICollectionViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var balanceLabel: UILabel!

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
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress(gesture:)))
//        longPress.minimumPressDuration = 0.2
        self.addGestureRecognizer(longPress)
    }
    
    @objc func longPress(gesture: UILongPressGestureRecognizer){
        switch gesture.state {
        case .began:
            UIView.animate(withDuration: 0.3) {
                self.transform = CGAffineTransform.init(scaleX: 0.9, y: 0.9)
                self.background.alpha = 1
            }
            let vc = TransferPopUp.make(address: "", coin: coin)
            vc.modalPresentationStyle = .overCurrentContext
            UIApplication.topViewController()?.present(vc, animated: false, completion: nil)
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
    
    func configure(item: TokenArrayItem) {
        guard let info = item.tokenInfo else {
            return
        }
        
        coin = Coin.ERC20(token: ERC20(item: item))
        
        animationButton.currentButtonType = .buttonUpBasicType
        animationButton.tintColor = AliceColor.green
        
        nameLabel.text = info.name
        let num = pow(Double(10.0), Double(info.decimals))
        let amount = Double(item.balance / num)
        amountLabel.text = "\(amount.toString(decimal: 3)) \(info.symbol!)"

        if let price = info.price {
            priceLabel.text = "$ \(Double(price.rate).toString(decimal: 3))"
            balanceLabel.text = "$ \((amount * Double(price.rate)).toString(decimal: 3))"
        } else {
            priceLabel.text = "Coin"
            balanceLabel.text = ""
        }

//        let address = info.address
        coinImageView.kf.setImage(with: coin.image, placeholder: Constant.placeholder)
    }

    func configure(item: BlockChain) {
        
        coin = Coin.coin(chain: item)
        
        nameLabel.text = item.rawValue
        coinImageView.kf.setImage(with: Coin.coin(chain: item).image, placeholder: Constant.placeholder)
        amountLabel.text = ""
        priceLabel.text = ""
        balanceLabel.text = ""

        guard let info = item.data else {
            return
        }
        
        let currency = PriceHelper.shared.currentCurrency
        guard let quote = info.quote?.toJSON() else {
                return
        }
        
        if !quote.keys.contains(currency.rawValue) {
            return
        }
        
        let price = quote[currency.rawValue] as! [String: Any]
        guard let currencyModel = CoinMarketCapCurrencyModel.deserialize(from: price) else {
            return
        }
        
        priceLabel.text = "\(currency.symbol) \(currencyModel.price!.toString(decimal: 3))"
        if Double(currencyModel.percent_change_24h!) > 0.0 {
            animationButton.currentButtonType = .buttonUpBasicType
            animationButton.tintColor = AliceColor.green
        } else {
            animationButton.currentButtonType = .buttonDownBasicType
            animationButton.tintColor = AliceColor.red
        }
    }
}
