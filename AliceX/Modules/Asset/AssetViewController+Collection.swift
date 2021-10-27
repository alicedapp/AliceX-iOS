//
//  AssetViewController+Collection.swift
//  AliceX
//
//  Created by lmcmz on 27/10/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import SwiftyUserDefaults
import ViewAnimator

extension AssetViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = indexPath.section
        guard let type = Asset(rawValue: section) else {
            return CGSize.zero
        }
        return type.size
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
        return 1
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return 1
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Asset.balance.name, for: indexPath) as! AssetBalanceCell
            cell.configure(isHidden: assetHide, newBalance: balance ?? Defaults[\.lastAssetBalance])
            cell.action = {
                self.assetHide = !self.assetHide
                Defaults[\.isHideAsset] = self.assetHide
                self.collectionView.reloadData()
            }
            return cell
        case Asset.coinHeader.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Asset.coinHeader.name, for: indexPath) as! AssetCoinHeaderCell
            cell.configure(count: coins.count, isClose: coinHide)
            cell.action = {
                self.coinHide = !self.coinHide
                //                if self.coinHide {
                //                    self.coinSectionCloseAnimation()
                //                } else {
                self.coinSectionShowAnimation()
                //                }
            }
            return cell
        case Asset.coin.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Asset.coin.name, for: indexPath) as! AssetCoinCell
            let coin = coins[indexPath.item]
            cell.configure(coin: coin, isHidden: assetHide)
            return cell
        case Asset.emptyCoin.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Asset.emptyCoin.name, for: indexPath) as! AddCoinCell
            return cell
        case Asset.NFTHeader.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Asset.NFTHeader.name, for: indexPath) as! AssetNFTHeaderCell
            cell.configure(count: NFTData.count, isClose: NFTHide)
            cell.action = {
                self.NFTHide = !self.NFTHide
                //                if self.NFTHide {
                //                    self.NFTSectionCloseAimation()
                //                } else {
                self.NFTSectionShowAimation()
                //                }
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

    func numberOfSections(in _: UICollectionView) -> Int {
        return Asset.allCases.count
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case Asset.coin.rawValue:
            return coinHide ? 0 : coins.count
        case Asset.emptyCoin.rawValue:
            return coins.count <= 2 ? 1 : 0
        case Asset.NFTHeader.rawValue:
            //            if let NFT = NFTData {
            //                return NFT.count > 0 ? 1 : 0
            //            }
            return NFTData.count > 0 ? 1 : 0
        //            return 1
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

    func coinSectionShowAnimation() {
        self.collectionView.reloadSections(IndexSet(arrayLiteral: Asset.coinHeader.rawValue,
                                                    Asset.coin.rawValue,
                                                    Asset.emptyCoin.rawValue))
        let coinCell = self.collectionView!.visibleCells(in: Asset.coin.rawValue)

        let orderCell = coinCell.sorted { (cell1, cell2) -> Bool in
            let index1 = self.collectionView.indexPath(for: cell1)!
            let index2 = self.collectionView.indexPath(for: cell2)!
            return index1.item < index2.item
        }
        cellAnimation(cells: orderCell, animator: coinAnimations)
    }

    func coinSectionCloseAnimation() {
        let coinCell = self.collectionView!.visibleCells(in: Asset.coin.rawValue)

        let orderCell = coinCell.sorted { (cell1, cell2) -> Bool in
            let index1 = self.collectionView.indexPath(for: cell1)!
            let index2 = self.collectionView.indexPath(for: cell2)!
            return index1.item < index2.item
        }

        UIView.animate(views: orderCell,
                       animations: coinAnimations,
                       reversed: true,
                       initialAlpha: 1.0,
                       finalAlpha: 0.0,
                       completion: {
                        self.collectionView.reloadSections(IndexSet(arrayLiteral: Asset.coinHeader.rawValue, Asset.coin.rawValue,
                                                                    Asset.emptyCoin.rawValue))
                       })
    }

    func erc20SectionAimation() {
        //        self.collectionView.reloadSections(IndexSet(arrayLiteral: Asset.erc20.rawValue))
        //        let animateCell = self.collectionView!.visibleCells(in: Asset.erc20.rawValue)
        //        cellAnimation(cells: animateCell, animator: coinAnimations)
    }

    func NFTSectionShowAimation() {
        self.collectionView.reloadSections(IndexSet(arrayLiteral: Asset.NFTHeader.rawValue, Asset.NFT.rawValue))
        let animateCell = self.collectionView!.visibleCells(in: Asset.NFT.rawValue)
        let orderCell = animateCell.sorted { (cell1, cell2) -> Bool in
            let index1 = self.collectionView.indexPath(for: cell1)!
            let index2 = self.collectionView.indexPath(for: cell2)!
            return index1.item < index2.item
        }
        cellAnimation(cells: orderCell, animator: animations)
    }

    func NFTSectionCloseAimation() {
        let animateCell = self.collectionView!.visibleCells(in: Asset.NFT.rawValue)

        let orderCell = animateCell.sorted { (cell1, cell2) -> Bool in
            let index1 = self.collectionView.indexPath(for: cell1)!
            let index2 = self.collectionView.indexPath(for: cell2)!
            return index1.item < index2.item
        }

        UIView.animate(views: orderCell,
                       animations: animations,
                       reversed: true,
                       initialAlpha: 1.0,
                       finalAlpha: 0.0,
                       completion: {
                        self.collectionView.reloadSections(IndexSet(arrayLiteral: Asset.NFTHeader.rawValue, Asset.NFT.rawValue))
                       })
    }
}
