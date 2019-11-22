//
//  MiniAppViewController.swift
//  AliceX
//
//  Created by lmcmz on 12/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Hero
import UIKit

class MiniAppViewController: BaseViewController {

    weak var tabRef: UIStackView!
    
    @IBOutlet var naviContainer: UIView!
    @IBOutlet var deleteZone: UIView!
    @IBOutlet var deleteLabel: UILabel!
    
    var scrollViewCover: UIView!
    var scrollViewBG: UIView!
    var collectionColor: UIColor!
    
    @IBOutlet var backIndicator: UIImageView!
    @IBOutlet var backButton: UIView!

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
//        vc.view.frame = CGRect(x: 0, y: 0, width: Constant.SCREEN_WIDTH, height: Constant.SCREEN_HEIGHT)
        return vc
    }()

    var naviColor: UIColor = .white
    var data: [HomeItem] = []
    
    var selectIndexPath: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
//        collectionView.dragDelegate = self
//        collectionView.dropDelegate = self

        addChild(cameraVC)
        view.insertSubview(cameraVC.view, belowSubview: naviContainer)
        cameraVC.view.fillSuperview()
        cameraVC.didMove(toParent: self)
        cameraVC.willMove(toParent: self)
        cameraVC.view.fillSuperview()

        cameraVC.block = { result in
            self.coverClick()
            if result.isValidURL {
                let vc = BrowserWrapperViewController.make(urlString: result)
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                HUDManager.shared.showErrorAlert(text: result, isAlert: true)
            }
        }
        // cameraVC.view.transform = CGAffineTransform.init(scaleX: 0.3, y: 0.3)
        naviColor = naviContainer.backgroundColor!

//        backButton.transform = CGAffineTransform.init(translationX: 0, y: 30)
//        backIndicator.transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi / 2))
        for cell in MiniAppTab.allCases {
            collectionView.registerCell(nibName: cell.name)
        }
        
        collectionColor = collectionView.backgroundColor
        
        scrollViewBG = UIView()
        scrollViewBG.isUserInteractionEnabled = false
        scrollViewBG.backgroundColor = collectionView.backgroundColor
        scrollViewBG.layer.cornerRadius = 40
        scrollViewBG.layer.zPosition = -1
        collectionView.insertSubview(scrollViewBG, belowSubview: collectionView)
        scrollViewBG.fillSuperview()
//        collectionView.backgroundView = scrollViewBG
        
        scrollViewCover = UIView()
        scrollViewCover.backgroundColor = UIColor(white: 0, alpha: 0.3)
        scrollViewCover.alpha = 0
        scrollViewCover.layer.cornerRadius = 40
        collectionView.addSubview(scrollViewCover)
        collectionView.bringSubviewToFront(scrollViewCover)
        scrollViewCover.fillSuperview()
        
//        scrollViewBG.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(coverClick))
        scrollViewCover.addGestureRecognizer(tap)
        scrollViewCover.isUserInteractionEnabled = false
        
//        let pan = UIPanGestureRecognizer(target: self, action: #selector(panHandler(gesture:)))
//        scrollViewCover.addGestureRecognizer(pan)
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        
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
        
        collectionView.layer.cornerRadius = 40
//        collectionView.roundCorners(corners: .allCorners, radius: 40)
//        view.bringSubviewToFront(deleteZone)
    }
    
    @IBAction func browserButtonClick() {
        let vc = BrowserWrapperViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func cameraButtonClick() {
        let vc = QRCodeReaderViewController.make { result in
            if result.isValidURL {
                let vc = BrowserWrapperViewController.make(urlString: result)
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                HUDManager.shared.showErrorAlert(text: result, isAlert: true)
            }
        }
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
//        navigationController?.pushViewController(vc, animated: true)
    }

    @available(iOS 12.0, *)
    override func themeDidChange(style: UIUserInterfaceStyle) {
        naviColor = style == .dark ? .black : .white
    }
}
