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

        containerView.bounds.size = CGSize(width: Constant.SCREEN_WIDTH * 0.8, height: 70)
        containerView.roundCorners(corners: [.bottomLeft, .topLeft], radius: containerView.frame.height / 2)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func layoutSubviews() {
        pinImageView.layer.cornerRadius = pinImageView.frame.height / 2

        layer.shadowColor = UIColor(hex: "#000000", alpha: 0.2).cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 5
    }

    func configure(item: PinItem, index: IndexPath) {
        self.item = item
        self.index = index
        switch item {
        case let .transaction(coin, network, txHash, title, vc):
            if let info = coin.info {
                pinImageView.kf.setImage(with: coin.image)
            } else {
                pinImageView.image = nil
            }

            pinTextLabel.text = title
            progressView.isHidden = false
            progressView.enableIndeterminate()
            self.vc = vc
        case let .dapplet(image, url, title, vc):
            pinImageView.kf.setImage(with: image)
            pinTextLabel.text = title
            progressView.isHidden = true
            self.vc = vc
        case let .website(image, url, title, vc):
            pinImageView.kf.setImage(with: image)
            pinTextLabel.text = title
            progressView.isHidden = true
            self.vc = vc
        case let .walletConnect(image, url, title, vc):
            pinImageView.kf.setImage(with: image, placeholder: Constant.placeholder)
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

        // TODO:
        guard let previousVC = self.previousVC else {
            return
        }

        guard let navi = previousVC.navigationController else {
            PinManager.shared.currentPin = item

            parentVC?.dismiss(animated: true, completion: {
                previousVC.present(self.vc, animated: true, completion: nil)
            })
            return
        }

        if navi.viewControllers.contains(vc) {
            if let vc = self.parentVC as? PinListViewController {
                vc.dismissVC()
            }
            return
        }

        PinManager.shared.currentPin = item
        PinTransitionPush.pushCellFrame = CGRect(x: frame.origin.x,
                                                 y: -frame.origin.y,
                                                 width: frame.width,
                                                 height: frame.height)

        parentVC?.dismiss(animated: true, completion: {
            self.previousVC?.navigationController?.pushViewController(self.vc, animated: true)
            PinManager.shared.ball.isHidden = false
        })
    }

    @IBAction func closeButtonClick() {
        PinManager.shared.removePinItem(item: item)

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
