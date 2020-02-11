//
//  AssetDetailViewController.swift
//  AliceX
//
//  Created by lmcmz on 19/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import JXSegmentedView
import UIKit

class AssetDetailViewController: BaseViewController {
    @IBOutlet var sendAndRecevieContainer: UIView!
    @IBOutlet var segmentedContainer: UIView!
    @IBOutlet var container: UIView!
    @IBOutlet var titleText: UILabel!

    var dataSource: JXSegmentedTitleImageDataSource!
    var segmentedView = JXSegmentedView()
    var listContainerView: JXSegmentedListContainerView!

    var coins: [Coin] = WatchingCoinHelper.shared.list

    var currentCoin: Coin = .coin(chain: .Ethereum) {
        didSet {
            if currentCoin != oldValue {
//                requestData()
//                updateCoin()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.interactivePopGestureRecognizer?.delegate = self

        segmentedView.delegate = self
        segmentedContainer.addSubview(segmentedView)
        segmentedView.fillSuperview()

        dataSource = JXSegmentedTitleImageDataSource()
        dataSource.titleNormalColor = AliceColor.darkGrey()
        dataSource.titleSelectedColor = AliceColor.white()
        dataSource.isTitleColorGradientEnabled = true
        dataSource.titleImageType = .leftImage
        dataSource.isImageZoomEnabled = false
        dataSource.titles = coins.compactMap { $0.info?.symbol }
        dataSource.normalImageInfos = coins.compactMap { $0.image.absoluteString }
        dataSource.imageSize = CGSize(width: 15, height: 15)
        dataSource.loadImageClosure = { imageView, normalImageInfo in
            imageView.kf.setImage(with: URL(string: normalImageInfo), placeholder: Constant.placeholder)
        }

        segmentedView.dataSource = dataSource

        let indicator = JXSegmentedIndicatorBackgroundView()
//        indicator.isIndicatorConvertToItemFrameEnabled = true
        indicator.indicatorHeight = 30
        indicator.indicatorColor = AliceColor.darkGrey()
        segmentedView.indicators = [indicator]
        
        listContainerView = JXSegmentedListContainerView(dataSource: self, type: .collectionView)
        segmentedView.listContainer = listContainerView
        segmentedView.contentScrollView = listContainerView.scrollView

//        segmentedView.contentScrollView?.delegate = self

        container.addSubview(listContainerView)
        listContainerView.fillSuperview()

//       if let index = chains.firstIndex(of: selectBlockCahin) {
//           segmentedView.defaultSelectedIndex = index
//       }
//        setupChartView()
//        requestData()

        if let index = coins.firstIndex(of: currentCoin) {
            segmentedView.defaultSelectedIndex = index
        }
        
//        updateCoin()
    }
    
    override func viewDidLayoutSubviews() {
//        segmentedView.indicators.first!.centerInSuperview()
    }

//    func updateCoin() {
//        titleText.text = currentCoin.info?.name
//        titleAnimation()
//    }

    func titleAnimation() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        transition.type = CATransitionType(rawValue: "cube")
        transition.subtype = CATransitionSubtype.fromTop
        titleText.layer.add(transition, forKey: "country1_animation")
    }

    func mainTabScroll(offset: CGFloat) {
        if offset >= 0 {
            UIView.animate(withDuration: 0.3) {
                self.sendAndRecevieContainer.transform = CGAffineTransform.identity
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.sendAndRecevieContainer.transform = CGAffineTransform(translationX: 0, y: 104)
            }
        }
    }
    
    @IBAction func receiveButtonClick() {
        let vc = AddressQRCodeViewController()
        vc.selectBlockCahin = currentCoin.blockchain
        HUDManager.shared.showAlertVCNoBackground(viewController: vc, haveBG: true)
    }
    
    @IBAction func sendButtonClick() {
        let vc = TransferPopUp.make(address: "", coin: currentCoin)
        vc.modalPresentationStyle = .overCurrentContext
        UIApplication.topViewController()?.present(vc, animated: false, completion: nil)
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
}
