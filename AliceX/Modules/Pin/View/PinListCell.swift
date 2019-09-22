//
//  PinListCell.swift
//  AliceX
//
//  Created by lmcmz on 1/9/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit

class PinListCell: UITableViewCell {
    var previousVC: UIViewController?
    var parentVC: UIViewController?

    @IBOutlet var pinImageView: UIImageView!
    @IBOutlet var pinTextLabel: UILabel!
    @IBOutlet var progressView: RPCircularProgress!

    @IBOutlet var containerView: UIView!
    
    var item: PinItem!
    var index: IndexPath!
    var vc: UIViewController!

    override func awakeFromNib() {
        super.awakeFromNib()
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

    func configure(item: PinItem, index: IndexPath) {
        self.item = item
        self.index = index
        switch item {
        case .transaction(let network, let txHash, let title, let vc):
            pinImageView.image = UIImage.imageWithColor(color: network.color)
            pinTextLabel.text = title
            progressView.isHidden = false
            self.vc = vc
        case .dapplet(let image, let url, let title, let vc):
            pinImageView.image = image
            pinTextLabel.text = title
            progressView.isHidden = true
            progressView.enableIndeterminate()
            self.vc = vc
        case .website(let image, let url, let title, let vc):
            pinImageView.image = image
            pinTextLabel.text = title
            progressView.isHidden = true
            self.vc = vc
        }
    }

    @IBAction func enterClick(sender: UIControl) {
        guard let frame = sender.superview?.convert(sender.frame, from: UIApplication.topViewController()?.view) else {
            return
        }
//        if (frame?.origin.y)! < CGFloat(0) {
//            frame?.origin.y = -(frame?.origin.y)!
//        }
        
        guard let previousVC = self.parentVC else {
            return
        }
        
        if (self.previousVC?.navigationController?.viewControllers.contains(vc))! {
            if let vc = self.parentVC as? PinListViewController {
                vc.dismissVC()
            }
            return
        }
        
        PinManager.shared.currentPin = self.item
        
        PinTransitionPush.pushCellFrame = CGRect(x: frame.origin.x,
                                                 y: -frame.origin.y,
                                                 width: frame.width,
                                                 height: frame.height)

        parentVC?.dismiss(animated: true, completion: {
            self.previousVC?.navigationController?.pushViewController(self.vc, animated: true)
        })
    }

    @IBAction func closeButtonClick() {
        PinManager.shared.removePinItem(item: self.item)
        
        if let vc = self.parentVC as? PinListViewController {
            
//            vc.pinList = PinManager.shared.pinList
//            vc.tableView.deleteRows(at: [index], with: .automatic)
            
            vc.updateIfNeeded()
            
            if PinManager.shared.pinList.count == 0 {
                vc.dismissVC()
                return
            }
        }
    }
}
