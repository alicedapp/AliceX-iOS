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
    var tabs = MainTab.allCases

    let vcs = [ MiniAppViewController(),
                AssetViewController(),
                SettingViewController.make(hideBackButton: true)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        bounces = false
        view.backgroundColor = .clear
        Defaults[\.isFirstTimeOpen] = false
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
//        return .at(index: 1)
        return nil
    }
}

// extension MainTabViewController: UIScrollViewDelegate {
//    func scrollViewDidScroll(_: UIScrollView) {
//    }
// }
