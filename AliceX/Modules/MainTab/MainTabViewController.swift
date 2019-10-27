//
//  MainTabViewController.swift
//  AliceX
//
//  Created by lmcmz on 26/10/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit

class MainTabViewController: BaseViewController {
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
        scrollView.bounces = false
        scrollView.contentSize = CGSize(width: Constant.SCREEN_WIDTH * CGFloat(MainTab.allCases.count),
                                        height: Constant.SCREEN_HEIGHT)
        contentView.frame = CGRect(x: 0, y: 0,
                                   width: Constant.SCREEN_WIDTH * CGFloat(MainTab.allCases.count),
                                   height: Constant.SCREEN_HEIGHT)
        
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = true
        }
        
        for tab in MainTab.allCases {
            let index = tab.rawValue
            let vc = tab.vc
            vc.willMove(toParent: self)
            vc.view.frame = CGRect(x: Constant.SCREEN_WIDTH * CGFloat(index),
                                   y: 0,
                                   width: Constant.SCREEN_WIDTH,
                                   height: Constant.SCREEN_HEIGHT)
            contentView.addSubview(vc.view)
            addChild(vc)
            vc.didMove(toParent: self)
        }
    }
}

extension MainTabViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /// Disbale vertical scroll
    }
}
