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

