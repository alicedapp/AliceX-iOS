//
//  UITableView.swift
//  AliceX
//
//  Created by lmcmz on 10/6/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit

extension UITableView {
    func registerCell(nibName: String) {
        let nib = UINib(nibName: nibName, bundle: nil)
        register(nib, forCellReuseIdentifier: nibName)
    }

    func registerHeaderFooter(nibName: String) {
        let nib = UINib(nibName: nibName, bundle: nil)
        register(nib, forHeaderFooterViewReuseIdentifier: nibName)
    }
}

extension UITableView {
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = AliceColor.darkGrey()
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = .systemFont(ofSize: 17)
//            UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()

        backgroundView = messageLabel
        separatorStyle = .none
    }

    func restore() {
        backgroundView = nil
        separatorStyle = .singleLine
    }
}

extension UICollectionView {
    func registerCell(nibName: String) {
        let nib = UINib(nibName: nibName, bundle: nil)
        register(nib, forCellWithReuseIdentifier: nibName)
    }

    func registerHeaderFooter(nibName: String) {
        let nib = UINib(nibName: nibName, bundle: nil)
        register(nib, forSupplementaryViewOfKind: nibName, withReuseIdentifier: nibName)
    }
}
