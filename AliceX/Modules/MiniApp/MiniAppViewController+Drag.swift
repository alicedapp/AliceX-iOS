//
//  MiniAppViewController+Drag.swift
//  AliceX
//
//  Created by lmcmz on 22/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation

extension MiniAppViewController {
    @objc func longPress(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            let point = gesture.location(in: collectionView)
            let index = collectionView.indexPathForItem(at: point)
            guard let indexPath = index else {
                break
            }
            guard let cell = collectionView.cellForItem(at: indexPath) else {
                break
            }
            selectIndexPath = indexPath
            view.insertSubview(cell, aboveSubview: deleteZone)
            collectionView.beginInteractiveMovementForItem(at: indexPath)

            UIView.animate(withDuration: 0.3) {
                self.deleteZone.transform = CGAffineTransform(translationX: 0, y: -self.deleteZone.bounds.height)
                self.tabRef.alpha = 0
            }

        case .changed:
            let point = gesture.location(in: collectionView)
            collectionView.updateInteractiveMovementTargetPosition(point)

            guard let position = UIApplication.shared.keyWindow?.convert(point, to: deleteZone) else {
                break
            }

            if -position.y < deleteZone.bounds.height {
                isZoneHighlight = true
                deleteLabel.text = "Drop to delete"
            } else {
                isZoneHighlight = false
                deleteLabel.text = "Delete Zone"
            }

        case .ended:

            if isZoneHighlight {
                guard let indexPath = self.selectIndexPath else {
                    collectionView.endInteractiveMovement()
                    break
                }

                if !data[indexPath.item].isApp { // Enforce NOT allow delete mini App
                    if let cell = collectionView.cellForItem(at: indexPath) {
                        cell.isHidden = true
                    }

                    collectionView.endInteractiveMovement()
                    data.remove(at: indexPath.item)
                    collectionView.deleteItems(at: [indexPath])
                } else {
                    collectionView.endInteractiveMovement()
                }

            } else {
                collectionView.endInteractiveMovement()
            }

            UIView.animate(withDuration: 0.3) {
                self.deleteZone.transform = CGAffineTransform.identity
                self.tabRef.alpha = 1
            }
            HomeItemHelper.shared.updatList(list: data)

        default:
            collectionView.cancelInteractiveMovement()
        }
    }
}
