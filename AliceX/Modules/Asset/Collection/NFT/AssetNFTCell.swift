//
//  AssetNFTCell.swift
//  AliceX
//
//  Created by lmcmz on 27/10/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Kingfisher
//import SVGKit
import UIKit

class AssetNFTCell: UICollectionViewCell {
    @IBOutlet var contractImageView: UIImageView!
    @IBOutlet var contractName: UILabel!
    @IBOutlet var NFTImageView: UIImageView!
//    @IBOutlet var NFTSVGView: SVGKFastImageView!
//    @IBOutlet var backgroundImageView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(model: OpenSeaModel) {
        if let image = model.image_url, let imageURL = URL(string: image) {
            if image.hasSuffix(".svg") {
//                NFTSVGView.isHidden = false
//                NFTImageView.isHidden = true

//                let svg = UIView(SVGURL: imageURL, parser: nil) { svgLayer in
//                    svgLayer.resizeToFit(self.NFTImageView.bounds)
//                }
//                NFTSVGView.image = SVGKImage(contentsOf: imageURL)

                NFTImageView.kf.setImage(with: URL(string: model.image_preview_url!)!)
            } else {
//                NFTSVGView.isHidden = true
                NFTImageView.kf.setImage(with: imageURL)
            }
        } else {
            NFTImageView.image = nil
        }

        if let color = model.background_color {
            NFTImageView.backgroundColor = UIColor(hex: color)
        } else {
            NFTImageView.backgroundColor = UIColor(hex: "D5D5D5", alpha: 0.15)
        }

        if let image = model.asset_contract.image_url, let imageURL = URL(string: image) {
            contractImageView.kf.setImage(with: imageURL) { result in
                switch result {
                case .success(_):
                    self.contractImageView.backgroundColor = .clear
                default:
                    break
                }
            }
        } else {
            contractImageView.image = nil
        }

        contractName.text = model.name
    }
}
