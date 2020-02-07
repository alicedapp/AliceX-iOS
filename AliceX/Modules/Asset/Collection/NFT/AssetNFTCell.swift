//
//  AssetNFTCell.swift
//  AliceX
//
//  Created by lmcmz on 27/10/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Kingfisher
// import SVGKit
import UIKit

class AssetNFTCell: UICollectionViewCell {
    @IBOutlet var contractImageView: UIImageView!
    @IBOutlet var contractName: UILabel!
    @IBOutlet var NFTImageView: UIImageView!
//    @IBOutlet var NFTSVGView: SVGKFastImageView!
//    @IBOutlet var backgroundImageView: UIView!

    var model: OpenSeaModel?

    @IBOutlet var viewShadow: UIView!

    lazy var addressVC: AddressPopUp = {
        let vc = AddressPopUp.make(delegate: self, address: nil)
        return vc
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

//        let shadowLayer = CAShapeLayer()
//        shadowLayer.path = UIBezierPath(roundedRect: viewShadow.bounds, cornerRadius: 25).cgPath
//        shadowLayer.fillColor = UIColor.clear.cgColor
//        shadowLayer.shadowColor = UIColor(hex: "#000000", alpha: 0.3).cgColor
//        shadowLayer.shadowPath = shadowLayer.path
//        shadowLayer.shadowOffset = CGSize(width: 0, height: 1.0)
//        shadowLayer.shadowOpacity = 0.3
//        shadowLayer.shadowRadius = 5
//        viewShadow.layer.insertSublayer(shadowLayer, at: 0)

        viewShadow.layer.shadowColor = UIColor(hex: "#000000", alpha: 0.3).cgColor
        viewShadow.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        viewShadow.layer.shadowRadius = 2
        viewShadow.layer.shadowOpacity = 0.3

        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress(gesture:)))
//        longPress.minimumPressDuration = 0.3
        addGestureRecognizer(longPress)

        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        addGestureRecognizer(tap)
    }

    @objc func tapAction() {
        let topVC = UIApplication.topViewController()
        let vc = NFTDetailViewController.make(NFTModel: model!)
        topVC?.navigationController?.pushViewController(vc, animated: true)
    }

    @objc func longPress(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            UIView.animate(withDuration: 0.3) {
                self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
//                self.background.alpha = 1
            }
            if let NFTModel = self.model {
                addressVC.address = nil
                let vc = addressVC
                vc.modalPresentationStyle = .overCurrentContext
                UIApplication.topViewController()?.present(vc, animated: false, completion: nil)
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            }

        case .ended:
            UIView.animate(withDuration: 0.3) {
                self.transform = CGAffineTransform.identity
//                self.background.alpha = 0
            }
        default:
            break
        }
    }

    func configure(model: OpenSeaModel) {
        self.model = model

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

        if let image = model.asset_contract!.image_url, let imageURL = URL(string: image) {
            contractImageView.kf.setImage(with: imageURL) { result in
                switch result {
                case .success:
                    self.contractImageView.backgroundColor = .clear
                default:
                    break
                }
            }
        } else {
            contractImageView.image = nil
        }

        if let name = model.name, !name.isEmptyAfterTrim() {
            contractName.text = model.name
        } else {
            contractName.text = model.asset_contract?.name
        }
    }
}

extension AssetNFTCell: AddressPopUpDelegate {
    func comfirmedAddress(address: String) {
        guard let model = self.model else {
            return
        }

        TransactionManager.showERC721PopUp(toAddress: address,
                                           NFTModel: model) { _ in
            self.addressVC.cancelBtnClicked()
        }
    }
}
