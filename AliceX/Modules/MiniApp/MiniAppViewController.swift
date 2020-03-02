//
//  MiniAppViewController.swift
//  AliceX
//
//  Created by lmcmz on 12/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Hero
import UIKit
import VBFPopFlatButton
import web3swift

class MiniAppViewController: BaseViewController {
    weak var tabRef: UIStackView!

    @IBOutlet var naviContainer: UIView!
    @IBOutlet var deleteZone: UIView!
    @IBOutlet var deleteLabel: UILabel!

    var scrollViewCover: UIView!
    var scrollViewBG: UIView!
    var collectionColor: UIColor = UIColor(hex: "F1F4F5")

//    @IBOutlet var backIndicator: UIImageView!
    @IBOutlet var backButton: VBFPopFlatButton!

    @IBOutlet var titleLabel: UILabel!

    @IBOutlet var collectionView: UICollectionView!

    var overPlay: Bool = false
    var percentage: CGFloat = 0.0

    var isTriggle: Bool = false

    var isImpacted: Bool = false
    var isZoneHighlight: Bool = false {
        didSet {
            if isZoneHighlight {
                if !isImpacted {
                    let impactLight = UIImpactFeedbackGenerator(style: .medium)
                    impactLight.impactOccurred()
                    isImpacted = true
                }
            } else {
                isImpacted = false
            }
        }
    }

    lazy var cameraVC: CameraContainerViewController = { () -> CameraContainerViewController in
        let vc = CameraContainerViewController()
        return vc
    }()

    var data: [HomeItem] = []

    var selectIndexPath: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true

        addChild(cameraVC)
        view.insertSubview(cameraVC.view, belowSubview: naviContainer)
        cameraVC.view.fillSuperview()
        cameraVC.didMove(toParent: self)
        cameraVC.willMove(toParent: self)
        cameraVC.view.fillSuperview()

        cameraVC.block = { result in
            self.coverClick()

            if result == "" {
                return
            }
            
            if let _ = EthereumAddress(result) {
                let vc = TransferPopUp.make(address: result, coin: Coin.coin(chain: .Ethereum))
                vc.modalPresentationStyle = .overCurrentContext
                UIApplication.topViewController()?.present(vc, animated: false, completion: nil)
                return
            }

            if result.isValidURL {
                let vc = BrowserWrapperViewController.make(urlString: result)
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                HUDManager.shared.showErrorAlert(text: result, isAlert: true)
            }
        }

        for cell in MiniAppTab.allCases {
            collectionView.registerCell(nibName: cell.name)
        }

        scrollViewBG = UIView()
        scrollViewBG.isUserInteractionEnabled = false
        scrollViewBG.backgroundColor = AliceColor.lightBackground()
        scrollViewBG.layer.cornerRadius = 38
        scrollViewBG.layer.zPosition = -1
        collectionView.insertSubview(scrollViewBG, belowSubview: collectionView)
        scrollViewBG.fillSuperview()
//        collectionView.backgroundView = scrollViewBG

        scrollViewCover = UIView()
        scrollViewCover.backgroundColor = UIColor(white: 0, alpha: 0.3)
        scrollViewCover.alpha = 0
        scrollViewCover.layer.cornerRadius = 38
        collectionView.addSubview(scrollViewCover)
        collectionView.bringSubviewToFront(scrollViewCover)
        scrollViewCover.fillSuperview()

        backButton = VBFPopFlatButton(frame: CGRect(x: (Constant.SCREEN_WIDTH - 30) / 2, y: 8, width: 30, height: 10),
                                      buttonType: .buttonMinusType,
                                      buttonStyle: .buttonRoundedStyle,
                                      animateToInitialState: false)
        backButton.tintColor = AliceColor.greyNew()
        collectionView.addSubview(backButton)
        backButton.lineThickness = 5
        backButton.lineRadius = 4

//        scrollViewBG.isHidden = true

        let tap = UITapGestureRecognizer(target: self, action: #selector(coverClick))
        scrollViewCover.addGestureRecognizer(tap)
        scrollViewCover.isUserInteractionEnabled = false

//        let pan = UIPanGestureRecognizer(target: self, action: #selector(panHandler(gesture:)))
//        scrollViewCover.addGestureRecognizer(pan)

        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)

        HomeItemHelper.shared.loadFromCache().done { item in
            self.data = item
            self.homeItemAimation()

            let urls = self.data.filter { !$0.isApp }.compactMap { $0.url }
            FaviconHelper.prefetchFavicon(urls: urls)
        }

        NotificationCenter.default.addObserver(self, selector: #selector(listChange),
                                               name: .homeItemListChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(coverClick),
                                               name: .wallectConnectClientConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(coverClick),
                                               name: .wallectConnectServerConnect, object: nil)

        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress(gesture:)))
        collectionView.addGestureRecognizer(longPress)
    }

    @objc func listChange() {
        data = HomeItemHelper.shared.list
        collectionView.reloadData()
    }

    override func viewDidLayoutSubviews() {
        collectionView.layer.cornerRadius = 38
        let extendHeight: CGFloat = Constant.SAFE_BOTTOM == 0 ? 34.0 : 0
        let collectionFrame = collectionView.frame
        collectionView.frame = CGRect(x: collectionFrame.minX,
                                      y: collectionFrame.minY,
                                      width: collectionFrame.width,
                                      height: collectionFrame.height + extendHeight)
    }

    @IBAction func browserButtonClick() {
        let vc = BrowserWrapperViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func cameraButtonClick() {
//        let vc = QRCodeReaderViewController.make { result in
//            if result.isValidURL {
//                let vc = BrowserWrapperViewController.make(urlString: result)
//                self.navigationController?.pushViewController(vc, animated: true)
//            } else {
//                HUDManager.shared.showErrorAlert(text: result, isAlert: true)
//            }
//        }
//        vc.modalPresentationStyle = .fullScreen
//        present(vc, animated: true, completion: nil)
//        navigationController?.pushViewController(vc, animated: true)
        
        let vc = DAppListViewController()
        HUDManager.shared.showAlertVCNoBackground(viewController: vc, haveBG: true)
    }

    @available(iOS 12.0, *)
    override func themeDidChange(style _: UIUserInterfaceStyle) {
//        naviColor = style == .dark ? .black : .white
//        collectionColor = collectionView.backgroundColor as! UIColor
        scrollViewBG.backgroundColor = AliceColor.lightBackground()
    }

//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        super.traitCollectionDidChange(previousTraitCollection)
//        if #available(iOS 12.0, *) {
//            guard previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle else {
//                return
//            }
//
    ////            let userInterfaceStyle = traitCollection.userInterfaceStyle
//            scrollViewBG.backgroundColor = AliceColor.lightBackground()
//        }
//    }
}
