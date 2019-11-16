//
//  CoinReOrderCell.swift
//  AliceX
//
//  Created by lmcmz on 9/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Kingfisher
import UIKit

class CoinReOrderCell: UICollectionViewCell {
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var coinImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(coin: Coin) {
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

        nameLabel.text = info.symbol
    }
}
