//
//  PinListCell.swift
//  AliceX
//
//  Created by lmcmz on 1/9/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit

class PinListCell: UITableViewCell {
    @IBOutlet var pinImageView: UIImageView!
    @IBOutlet var pinTextLabel: UILabel!
    @IBOutlet var progressView: RPCircularProgress!

    @IBOutlet var containerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        progressView.enableIndeterminate()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func layoutSubviews() {
        pinImageView.layer.cornerRadius = pinImageView.frame.height / 2
        containerView.roundCorners(corners: [.bottomLeft, .topLeft], radius: containerView.frame.height / 2)
        layer.shadowColor = UIColor(hex: "#000000", alpha: 0.2).cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 5
    }

    func configure(image: UIImage, text: String, isTransaction: Bool) {
        pinImageView.image = image
        pinTextLabel.text = text
        progressView.isHidden = !isTransaction
    }

    @IBAction func closButtonClick() {}
}
