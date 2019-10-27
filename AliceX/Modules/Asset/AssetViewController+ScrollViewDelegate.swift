//
//  AssetViewController+ScrollViewDelegate.swift
//  AliceX
//
//  Created by lmcmz on 27/10/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation

extension AssetViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        
        var percent = y / 104
        
        if percent > 1 {
            percent = 1
        }
        
        if percent <= 0 {
            percent = 0
        }
        
//        let color = UIColor.interpolate(between: .white, and: UIColor(hex: "F5F5F5"), percent: percent)
        navBar.alpha = percent
//        navLabel.alpha = percent
//        navLine.alpha = percent
    }
    
}
