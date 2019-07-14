//
//  DappTableViewCell.swift
//  AliceX
//
//  Created by lmcmz on 14/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit
import Kingfisher

class DappTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var logoView: UIImageView!
    
    @IBOutlet weak var tagName: UILabel!
    @IBOutlet weak var tagView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(model: DAppModel) {
        titleLabel.text = model.name
        descLabel.text = model.description
        tagName.text = model.category
        logoView.kf.setImage(with: URL(string: model.img!)!,
                             placeholder: UIImage.imageWithColor(color: UIColor(hex: "F1F5F8")))
    }
    
}
