//
//  AssetViewController+Collection.swift
//  AliceX
//
//  Created by lmcmz on 27/10/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import ViewAnimator

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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Asset.coinHeader.name, for: indexPath) as! AssetCoinHeaderCell
            cell.action = {
                self.coinHide = !self.coinHide
                self.coinSectionAimation()
            }
            return cell
        case Asset.coin.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Asset.coin.name, for: indexPath) as! AssetCoinCell
            
            var chain = BlockChain.Ethereum
            switch item {
            case 1:
                chain = .Bitcoin
            case 2:
                chain = .Binance
            default:
                chain = .Ethereum
            }
            
            cell.configure(item: chain)
            return cell
        case Asset.erc20.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Asset.coin.name, for: indexPath) as! AssetCoinCell
            if let erc20 = erc20Data {
                let tokenInfo = erc20.tokens[item]
                cell.configure(item: tokenInfo)
            }
            return cell
            
        case Asset.NFTHeader.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Asset.NFTHeader.name, for: indexPath) as! AssetNFTHeaderCell
            cell.action = {
                self.NFTHide = !self.NFTHide
                self.collectionView.reloadSections(IndexSet(arrayLiteral: Asset.NFT.rawValue))
                self.collectionView.performBatchUpdates({
                    UIView.animate(views: self.collectionView!.visibleCells(in: Asset.NFT.rawValue),
                                   animations: self.animations,
                                   completion: nil)
                }, completion: nil)
            }
            return cell
        case Asset.NFT.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Asset.NFT.name, for: indexPath) as! AssetNFTCell
            if NFTData.count != 0 {
                let model = NFTData[item]
                cell.configure(model: model)
            }
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
        case Asset.coin.rawValue:
            return coinHide ? 0 : 3
        case Asset.erc20.rawValue:
            if let erc20 = erc20Data {
                return coinHide ? 0 : erc20.tokens.count
            }
            return 0
        case Asset.NFT.rawValue:
            if let NFT = NFTData {
                return NFTHide ? 0 : NFT.count
            }
            return 0
        default:
            return 1
        }
    }
    
    // Animation
    
    func cellAnimation(cells: [UICollectionViewCell], animator: [AnimationType]) {
        
        self.collectionView.performBatchUpdates({
            UIView.animate(views: cells,
                           animations: animator,
                           completion: nil)
        }, completion: nil)
    }
    
    func coinSectionAimation() {
        
        self.collectionView.reloadSections(IndexSet(arrayLiteral: Asset.erc20.rawValue, Asset.coin.rawValue))
        
        let coinCell = self.collectionView!.visibleCells(in: Asset.coin.rawValue)
        let erc20Cell = self.collectionView!.visibleCells(in: Asset.erc20.rawValue)
        let animateCell = coinCell + erc20Cell
        
//        self.collectionView.performBatchUpdates({
//            if !coinHide {
//                UIView.animate(views: animateCell,
//                               animations: self.coinAnimations,
//                               completion: nil)
//            } else {
//                UIView.animate(views: animateCell,
//                               animations: self.coinAnimations,
//                               reversed: true,
//                               initialAlpha: 1.0,
//                               finalAlpha: 0.0,
//                               completion: nil)
//            }
//        }, completion: nil)
        
        cellAnimation(cells: animateCell, animator: self.coinAnimations)
    }
    
    func erc20SectionAimation() {
        self.collectionView.reloadSections(IndexSet(arrayLiteral: Asset.erc20.rawValue))
        let animateCell = self.collectionView!.visibleCells(in: Asset.erc20.rawValue)
        cellAnimation(cells: animateCell, animator: self.coinAnimations)
    }
    
    func NFTSectionAimation() {
        
        self.collectionView.reloadSections(IndexSet(arrayLiteral: Asset.NFT.rawValue))
        let animateCell = self.collectionView!.visibleCells(in: Asset.NFT.rawValue)
        
        cellAnimation(cells: animateCell, animator: self.animations)
    }
}
