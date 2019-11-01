//
//  AddressQRCodeViewController.swift
//  AliceX
//
//  Created by lmcmz on 28/10/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit
import Kingfisher
import JXSegmentedView

//class AddressQRCodeViewController: UIViewController {
//
//    @IBOutlet var container: UIView!
//    @IBOutlet var shareConver: UIView!
//
//    @IBOutlet var addrssContainer: UIView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let child = AddressQRViewController()
//        addChildVCToView(childController: child, onView: container)
//    }
//}

class AddressQRCodeViewController: UIViewController {
    
    @IBOutlet var segmentedContainer: UIView!
    @IBOutlet var container: UIView!
    @IBOutlet var shareConver: UIView!
    
    @IBOutlet var addrssContainer: UIView!
    
    var selectBlockCahin: BlockChain = .Ethereum
    var dataSource: JXSegmentedTitleImageDataSource!
    var segmentedView = JXSegmentedView()
    var listContainerView: JXSegmentedListContainerView!
    
    let chains = BlockChain.allCases
    
    var listVCArray: [BlockChainQRCodeView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let index = BlockChain.allCases.firstIndex(of: selectBlockCahin)!
        
        segmentedView.delegate = self
        segmentedContainer.addSubview(segmentedView)
        
        dataSource = JXSegmentedTitleImageDataSource()
        dataSource.titleNormalColor = UIColor(hex: "AAAAAA", alpha: 1)
        dataSource.titleSelectedColor = AliceColor.dark
        dataSource.isTitleColorGradientEnabled = true
        dataSource.titleImageType = .topImage
        dataSource.isImageZoomEnabled = false
        dataSource.titles = chains.compactMap { $0.rawValue }
        dataSource.normalImageInfos = chains.compactMap { $0.image }
        dataSource.imageSize = CGSize(width: 40, height: 40)
        dataSource.loadImageClosure = {(imageView, normalImageInfo) in
            imageView.kf.setImage(with: URL(string: normalImageInfo), placeholder: Constant.placeholder)
         }

        segmentedView.dataSource = dataSource
        
        //配置指示器
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
        indicator.lineStyle = .lengthenOffset
        indicator.indicatorColor = AliceColor.dark
        segmentedView.indicators = [indicator]
        
        listContainerView = JXSegmentedListContainerView(dataSource: self, type: .scrollView)
        segmentedView.listContainer = listContainerView
        
        container.addSubview(listContainerView)
        segmentedView.fillSuperview()
        listContainerView.fillSuperview()
        
        segmentedView.defaultSelectedIndex = index
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    @IBAction func backBtnWithHUDManager() {
        HUDManager.shared.dismiss()
    }

    @IBAction func copyBtnClicked() {
        let index = segmentedView.selectedIndex
        let chain = chains[index]
        UIPasteboard.general.string = WalletCore.shared.address(blockchain: chain)
    }

    @IBAction func shareBtnClicked() {
        shareConver.isHidden = false
        let image = addrssContainer.snapshot()
        HUDManager.shared.dismiss()
        
        let index = segmentedView.selectedIndex
        let chain = chains[index]
        let address = WalletCore.shared.address(blockchain: chain)
        ShareHelper.share(text: address, image: image, urlString: "")
        shareConver.isHidden = true
    }
}

extension AddressQRCodeViewController: JXSegmentedListContainerViewDataSource, JXSegmentedViewDelegate {
    
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return chains.count
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        
        let chain = chains[index]
        let vc = ListBaseViewController()
        let view = BlockChainQRCodeView.instanceFromNib()
        view.chain = chain
        view.configure()
        vc.view.addSubview(view)
        view.fillSuperview()
        view.layoutIfNeeded()
        return vc
    }
}

class ListBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = UIColor(red: CGFloat(arc4random()%255)/255,
//                                       green: CGFloat(arc4random()%255)/255,
//                                       blue: CGFloat(arc4random()%255)/255, alpha: 1)
    }
}
