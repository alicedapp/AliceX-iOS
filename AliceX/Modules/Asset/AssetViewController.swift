//
//  AssetViewController.swift
//  AliceX
//
//  Created by lmcmz on 26/10/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit
import SPStorkController
import SwipeCellKit

class AssetViewController: BaseViewController {

    @IBOutlet var navLabel: UILabel!
    @IBOutlet var navLine: UIView!
    @IBOutlet var navBar: UIView!
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        
        for cell in Asset.allCases {
            collectionView.registerCell(nibName: cell.name)
        }
    }

    @IBAction func settingClick() {
        let vc = SettingViewController()
        let navi = BaseNavigationController(rootViewController: vc)
        let transitionDelegate = SPStorkTransitioningDelegate()
        navi.transitioningDelegate = transitionDelegate
        navi.modalPresentationStyle = .custom
        presentAsStork(navi, height: nil, showIndicator: false, showCloseButton: false)
    }
}

extension AssetViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = indexPath.section
        guard let type = Asset(rawValue: section) else {
            return CGSize.zero
        }
        return type.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == Asset.NFT.rawValue {
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
        return UIEdgeInsets.zero
    }
}

extension AssetViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let section = indexPath.section
        let item = indexPath.item

        switch section {
        case Asset.balance.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Asset.balance.name, for: indexPath)
            return cell
        case Asset.coinHeader.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Asset.coinHeader.name, for: indexPath)
            return cell
        case Asset.coin.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Asset.coin.name, for: indexPath)
            return cell
        case Asset.NFTHeader.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Asset.NFTHeader.name, for: indexPath)
            return cell
        case Asset.NFT.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Asset.NFT.name, for: indexPath)
            return cell
        default:
            guard let type = Asset(rawValue: section) else {
                return UICollectionViewCell()
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: type.name, for: indexPath)
            return cell
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Asset.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case Asset.balance.rawValue:
            return 1
        case Asset.coinHeader.rawValue:
            return 1
        case Asset.coin.rawValue:
            return 3
        case Asset.NFTHeader.rawValue:
            return 1
        case Asset.NFT.rawValue:
            return 10
        default:
            return 0
        }
    }
}
