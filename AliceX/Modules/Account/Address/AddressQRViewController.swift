//
//  AddressQRViewController.swift
//  AliceX
//
//  Created by lmcmz on 1/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import Pageboy
import Tabman

// class AddressQRViewController: TabmanViewController {
//
//    @IBOutlet var segmentedContainer: UIView!
//
//    @IBOutlet var container: UIView!
//    @IBOutlet var shareConver: UIView!
//
//    @IBOutlet var addrssContainer: UIView!
//
//    var selectBlockCahin: BlockChain = .Ethereum
//
//    let chains = BlockChain.allCases
//
//    var listVCArray: [BlockChainQRCodeView] = []
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        dataSource = self
//        let bar = TMBar.ButtonBar()
//        bar.frame = CGRect(x: 0, y: 0, width: Constant.SCREEN_WIDTH - 20, height: 110)
//        bar.layout.transitionStyle = .progressive
//        bar.backgroundColor = .clear
//        bar.tintColor = AliceColor.grey
//        addBar(bar, dataSource: self, at: .custom(view: segmentedContainer, layout: nil))
//    }
// }
//
// extension AddressQRViewController : PageboyViewControllerDataSource, TMBarDataSource {
//
//    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
//        return chains.count
//    }
//
//    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
//        let chain = chains[index]
//        let vc = BlockChainQRCodeViewController()
//        vc.chain = chain
//        return vc
//    }
//
//    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
//        return nil
//    }
//
//    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
//        let title = "Page \(index)"
//
////        TMBarItem(title: <#T##String#>, image: <#T##UIImage#>)
//        return TMBarItem(title: title)
//    }
// }
