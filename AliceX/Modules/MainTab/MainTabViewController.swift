//
//  MainTabViewController.swift
//  AliceX
//
//  Created by lmcmz on 26/10/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Pageboy
import SwiftyUserDefaults
import UIKit

class MainTabViewController: PageboyViewController {
    @IBOutlet var container: UIView!
    @IBOutlet var tab1Conatiner: UIView!
    @IBOutlet var tab2Conatiner: UIView!
    @IBOutlet var tab3Conatiner: UIView!
    
    @IBOutlet var tab1Icon: UIImageView!
    @IBOutlet var tab2Icon: UIImageView!
    @IBOutlet var tab3Icon: UIImageView!
    
    var tabs = MainTab.allCases
    
    var defaultPage: MainTab = MainTab.asset

    let vcs = [ MiniAppViewController(),
                AssetViewController(),
                SettingViewController.make(hideBackButton: true)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        bounces = false
        view.backgroundColor = .clear
        Defaults[\.isFirstTimeOpen] = false
        
        for tag in 1...3 {
            guard let tagView = view.viewWithTag(tag) else {
                continue
            }
            tagView.layer.shadowColor = UIColor(hex: "#000000", alpha: 0.5).cgColor
            tagView.layer.shadowOpacity = 0.5
            tagView.layer.shadowOffset = CGSize(width: 0, height: 2)
            tagView.layer.shadowRadius = 5
        }
        
        tab2Icon.alpha = 0
    }
    
    @IBAction func tabClick(button: UIControl) {
        let tag = button.tag - 1
        scrollToPage(.at(index: tag), animated: true)
    }
}

extension MainTabViewController: PageboyViewControllerDataSource {
    func numberOfViewControllers(in _: PageboyViewController) -> Int {
        return tabs.count
    }

    func viewController(for _: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
//        let tab = tabs[index]
        return vcs[index]
    }

    func defaultPage(for _: PageboyViewController) -> PageboyViewController.Page? {
        return .at(index: defaultPage.rawValue)
    }
}

extension MainTabViewController: PageboyViewControllerDelegate {
    
       func pageboyViewController(_ pageboyViewController: PageboyViewController,
                                   willScrollToPageAt index: PageboyViewController.PageIndex,
                                   direction: PageboyViewController.NavigationDirection,
                                   animated: Bool) {
    //        print("willScrollToPageAtIndex: \(index)")
        }
        
        func pageboyViewController(_ pageboyViewController: PageboyViewController,
                                   didCancelScrollToPageAt index: PageboyViewController.PageIndex,
                                   returnToPageAt previousIndex: PageboyViewController.PageIndex) {
            print("didCancelScrollToPageAt: \(index), returnToPageAt: \(previousIndex)")
        }
        
        func pageboyViewController(_ pageboyViewController: PageboyViewController,
                                   didScrollTo position: CGPoint,
                                   direction: PageboyViewController.NavigationDirection,
                                   animated: Bool) {
            print("didScrollToPosition: \(position)")
            let x = position.x
            if x >= 0 && x <= 1.0 {
                let alpha = x
                tab1Icon.alpha = alpha
                tab2Icon.alpha = 1 - alpha
            }
            
            if x >= 1 && x <= 2.0 {
                let alpha = x - 1
                tab2Icon.alpha = alpha
                tab3Icon.alpha = 1 - alpha
            }
        }
        
        func pageboyViewController(_ pageboyViewController: PageboyViewController,
                                   didScrollToPageAt index: PageboyViewController.PageIndex,
                                   direction: PageboyViewController.NavigationDirection,
                                   animated: Bool) {
            print("didScrollToPageAtIndex: \(index)")
//
//            gradient?.gradientOffset = CGFloat(index)
//            statusView.currentIndex = index
//            updateBarButtonsForCurrentIndex()
        }
        
        func pageboyViewController(_ pageboyViewController: PageboyViewController,
                                   didReloadWith currentViewController: UIViewController,
                                   currentPageIndex: PageIndex) {
        }
    
 }
