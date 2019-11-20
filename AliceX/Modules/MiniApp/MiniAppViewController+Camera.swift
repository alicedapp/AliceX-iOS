//
//  MiniAppViewController+Camera.swift
//  AliceX
//
//  Created by lmcmz on 20/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation

extension MiniAppViewController {
    @objc func coverClick() {
        isTriggle = false

        percentage = 0.0

        UIView.animate(withDuration: 0.3, animations: {
            self.scrollViewCover.alpha = 0.0
            self.scrollViewCover.isUserInteractionEnabled = false
            self.cameraVC.view.transform = CGAffineTransform(scaleX: 1.2, y: 1.3)

            self.naviContainer.transform = CGAffineTransform.identity
            self.naviContainer.backgroundColor = self.naviColor

            self.collectionView.frame = CGRect(x: 0, y: 104,
                                               width: Constant.SCREEN_WIDTH,
                                               height: Constant.SCREEN_HEIGHT - 104)
            self.collectionView.roundCorners(corners: [.topLeft, .topRight], radius: 0)
            self.rnContainer.roundCorners(corners: [.topLeft, .topRight], radius: 0)
            self.naviContainer.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 0)

            self.cameraVC.blurView.alpha = 1

        }) { _ in
//            self.scrollView.isUserInteractionEnabled = true
            self.collectionView.isScrollEnabled = true
            self.cameraVC.disableCamera()
        }

        view.layoutIfNeeded()
    }
}

extension MiniAppViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y

        if y > 0 {
//            scrollView.backgroundColor = naviColor
//            scrollView.bounces = false
            let percentage = min(max(y / 104, 0), 1.0)
            titleLabel.alpha = percentage
            return
        }

//        scrollView.bounces = true
//        scrollView.backgroundColor = .clear

        if isTriggle {
            return
        }

        let percentage = min(max(-y / 120, 0), 1.0)
        let slowPercentage = min(max(-y / 250, 0), 1.0)

        if y < -120 {
            if !overPlay {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                overPlay = true
            }
        } else {
            overPlay = false
        }

        if percentage > 1 {
            return
        }

        self.percentage = percentage

        print(percentage)

//        updateCameraVC(slowPercentage: slowPercentage)
//        updateStyle(slowPercentage: slowPercentage)
    }

    func updateStyle(slowPercentage _: CGFloat) {
//        let color = self.naviColor.interpolate(between: .brown, percent: self.percentage)
//        rnContainer.backgroundColor = color
        rnContainer.roundCorners(corners: [.topLeft, .topRight], radius: 40 * percentage)

        let naviColor = self.naviColor.toColor(.clear, percentage: percentage * 100)
        naviContainer.backgroundColor = naviColor
        naviContainer.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 40 * percentage)
        naviContainer.transform = CGAffineTransform(translationX: 0, y: -120 * percentage)

        scrollViewCover.alpha = percentage
    }

    func updateCameraVC(slowPercentage: CGFloat) {
        cameraVC.view.transform = CGAffineTransform(scaleX: 1.2 - 0.2 * percentage,
                                                    y: 1.3 - 0.3 * percentage)

        cameraVC.blurView.alpha = 1 - slowPercentage
//        let bounds = cameraVC.view.bounds
//        cameraVC.view.frame = CGRect(x: (bounds.size.width - Constant.SCREEN_WIDTH * percentage) / 2.0,
//                                     y: bounds.size.height - Constant.SCREEN_HEIGHT * percentage,
//                                     width: Constant.SCREEN_WIDTH * percentage,
//                                     height: Constant.SCREEN_HEIGHT * percentage)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity _: CGPoint, targetContentOffset _: UnsafeMutablePointer<CGPoint>) {
        let offsetY = scrollView.contentOffset.y

        if offsetY < -120 {
            isTriggle = true

            percentage = 1.0

//            UIView.animate(withDuration: 0.3, animations: {
//                self.scrollViewCover.alpha = 1.0
//                self.scrollViewCover.isUserInteractionEnabled = true
//                self.cameraVC.view.transform = CGAffineTransform.identity
//
//                self.collectionView.frame = CGRect(x: 0, y: Constant.SCREEN_HEIGHT - 120,
//                                               width: self.collectionView.bounds.width,
//                                               height: self.collectionView.bounds.height)
//                self.collectionView.roundCorners(corners: [.topLeft, .topRight], radius: 40)
//                self.naviContainer.transform = CGAffineTransform.init(translationX: 0, y: -120)
            ////                self.backButton.transform = CGAffineTransform.identity
            ////                self.backIndicator.transform = CGAffineTransform.identity
//            }) { (_) in
            ////                self.scrollView.isUserInteractionEnabled = false
//                self.collectionView.isScrollEnabled = false
//                self.cameraVC.activeCamera()
//                self.cameraVC.blurView.alpha = 0
//            }
        }
    }
}
