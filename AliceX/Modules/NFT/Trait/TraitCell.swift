//
//  TraitCell.swift
//  AliceX
//
//  Created by lmcmz on 2/2/20.
//  Copyright © 2020 lmcmz. All rights reserved.
//

import UIKit

class TraitCell: UICollectionViewCell {
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var textLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(type: String?, name: String?) {
        layer.shadowColor = UIColor(hex: "#000000", alpha: 0.5).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 5

        typeLabel.text = type?.split(separator: "_")
            .compactMap { String($0).firstCapitalized }
            .joined(separator: "").camelCaseToWords().uppercased()
        textLabel.text = name?.firstCapitalized
        sizeToFit()
    }
}
