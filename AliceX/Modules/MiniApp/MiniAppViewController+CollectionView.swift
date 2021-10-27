//
//  MiniAppViewController+CollectionView.swift
//  AliceX
//
//  Created by lmcmz on 20/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import ViewAnimator

extension MiniAppViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = indexPath.section
        guard let type = MiniAppTab(rawValue: section) else {
            return CGSize.zero
        }
        return type.size
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
        return 1
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return 5
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20)
    }
}

extension MiniAppViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in _: UICollectionView) -> Int {
        return MiniAppTab.allCases.count
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case MiniAppTab.homeItem.rawValue:
            return data.count
        case MiniAppTab.add.rawValue:
            return data.count > 3 ? 0 : 1
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section

        switch section {
        case MiniAppTab.homeItem.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MiniAppCollectionViewCell.nameOfClass,
                                                          for: indexPath) as! MiniAppCollectionViewCell
            let item = data[indexPath.item]
            cell.configure(item: item)
            return cell
        case MiniAppTab.add.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MiniAppAddCell.nameOfClass,
                                                          for: indexPath) as! MiniAppAddCell
            //            let item = data[indexPath.item]
            //            cell.configure(item: item)
            return cell
        default:
            guard let type = MiniAppTab(rawValue: section) else {
                return UICollectionViewCell()
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: type.name, for: indexPath)
            return cell
        }
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = data[indexPath.item]
        navigationController?.pushViewController(item.vc, animated: true)
    }

    func collectionView(_: UICollectionView, canMoveItemAt _: IndexPath) -> Bool {
        return true
    }

    func collectionView(_: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let sourceIndex = sourceIndexPath.row
        let destIndex = destinationIndexPath.row

        print(sourceIndex, destIndex)

        let item = data[sourceIndex]

        //        if item == nil {
        //            return
        //        }

        data.remove(at: sourceIndex)
        data.insert(item, at: destIndex)
    }
}

extension MiniAppViewController {
    func homeItemAimation() {
        collectionView.reloadSections(IndexSet(arrayLiteral: MiniAppTab.homeItem.rawValue,
                                               MiniAppTab.add.rawValue))

        let animateCell = collectionView!.visibleCells(in: MiniAppTab.homeItem.rawValue)
        let orderCell = animateCell.sorted { (cell1, cell2) -> Bool in
            let index1 = self.collectionView.indexPath(for: cell1)!
            let index2 = self.collectionView.indexPath(for: cell2)!
            return index1.item < index2.item
        }

        let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
        cellAnimation(cells: orderCell, animator: animations)
    }

    func cellAnimation(cells: [UICollectionViewCell], animator: [AnimationType]) {
        collectionView.performBatchUpdates({
            UIView.animate(views: cells,
                           animations: animator,
                           completion: nil)
        }, completion: nil)
    }
}
