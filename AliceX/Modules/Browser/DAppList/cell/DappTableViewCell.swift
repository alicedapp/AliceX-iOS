//
//  DappTableViewCell.swift
//  AliceX
//
//  Created by lmcmz on 14/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Kingfisher
import UIKit
import VBFPopFlatButton

class DappTableViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descLabel: UILabel!
    @IBOutlet var logoView: UIImageView!

    @IBOutlet var addButton: VBFPopFlatButton!
    @IBOutlet var addBackground: VBFPopFlatButton!
    
    @IBOutlet var tagName: UILabel!
    @IBOutlet var tagView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        addButton.currentButtonType = .buttonAddType
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
