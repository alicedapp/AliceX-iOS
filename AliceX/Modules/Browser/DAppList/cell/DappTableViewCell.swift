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

    @IBOutlet var addLabel: UILabel!
    @IBOutlet var addButton: VBFPopFlatButton!
    @IBOutlet var addBackground: UIView!
    
    @IBOutlet var dappView: UIView!

    @IBOutlet var tagName: UILabel!
    @IBOutlet var tagView: UIView!

    var item: HomeItem?

    override func awakeFromNib() {
        super.awakeFromNib()
        addButton.currentButtonStyle = .buttonRoundedStyle
        addButton.currentButtonType = .buttonAddType
        addButton.tintColor = .white
        addButton.lineRadius = 8
        addButton.lineThickness = 5
    }

    @IBAction func addButtonClick() {
        guard let item = self.item else {
            return
        }

        let isAdd = addButton.currentButtonType == .buttonAddType
        addButton.currentButtonType = isAdd ? .buttonOkType : .buttonAddType
//        addButton.tintColor = isAdd ? AliceColor.red : .white
        addLabel.text = isAdd ? "Added" : "Add"
        UIView.animate(withDuration: 0.3) {
            self.addBackground.backgroundColor = isAdd ? AliceColor.green : UIColor(hex: "9A9A9A", alpha: 0.5)
        }

        if isAdd {
            HomeItemHelper.shared.add(item: item)
        } else {
            HomeItemHelper.shared.remove(item: item)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(model: DAppModel) {
        titleLabel.text = model.name
        descLabel.text = model.description
        logoView.kf.setImage(with: URL(string: model.img!)!,
                             placeholder: UIImage.imageWithColor(color: UIColor(hex: "F1F5F8")))

        var link = model.link!
        if link.last == "/" {
            link = String(link.dropLast())
        }

        let url = URL(string: link)!
        var item = HomeItem.web(url: url)
        dappView.isHidden = true
        
        if model.type == .MiniApp, let dappName = model.dappName {
            item = HomeItem.app(name: dappName)
            dappView.isHidden = false
        }
        
        self.item = item
        let isAdd = HomeItemHelper.shared.contain(item: item)
        addButton.currentButtonType = isAdd ? .buttonOkType : .buttonAddType
//        addButton.tintColor = isAdd ? AliceColor.red : .white
        addLabel.text = isAdd ? "Added" : "Add"
        UIView.animate(withDuration: 0.3) {
            self.addBackground.backgroundColor = isAdd ? AliceColor.green : UIColor(hex: "9A9A9A", alpha: 0.5)
        }
    }
}
