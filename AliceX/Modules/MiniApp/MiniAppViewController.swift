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

    @IBOutlet var naviContainer: UIView!

    @IBOutlet var scrollViewCover: UIView!
    @IBOutlet var backIndicator: UIImageView!
    @IBOutlet var backButton: UIView!

    @IBOutlet var titleLabel: UILabel!

    @IBOutlet var collectionView: UICollectionView!

    var overPlay: Bool = false
    var percentage: CGFloat = 0.0

    var isTriggle: Bool = false

    lazy var cameraVC: CameraContainerViewController = { () -> CameraContainerViewController in
        let vc = CameraContainerViewController()
//        vc.view.frame = CGRect(x: 0, y: 0, width: Constant.SCREEN_WIDTH, height: Constant.SCREEN_HEIGHT)
        return vc
    }()

    var naviColor: UIColor = .white
    var data: [HomeItem] = [.app(name: "Example"),
                            .app(name: "DAOstack"),
                            .app(name: "Foam"),
                            .app(name: "CheezeWizards"),
                            .web(url: URL(string: "https://twitter.com")!),
                            .web(url: URL(string: "https://mycryptoheroes.net")!),
                            .web(url: URL(string: "https://uniswap.exchange")!),
                            .web(url: URL(string: "https://unipig.exchange")!),
                            .web(url: URL(string: "https://alicedapp.com")!)]

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
        collectionView.registerCell(nibName: MiniAppCollectionViewCell.nameOfClass)
        
        let urls = data.filter { !$0.isApp }.compactMap { $0.url }
        FaviconHelper.prefetchFavicon(urls: urls)
        
        scrollViewCover = UIView()
        scrollViewCover.backgroundColor = UIColor(white: 0, alpha: 0.3)
        scrollViewCover.alpha = 0
        collectionView.addSubview(scrollViewCover)
        scrollViewCover.fillSuperview()
        let tap = UITapGestureRecognizer(target: self, action: #selector(coverClick))
        scrollViewCover.addGestureRecognizer(tap)
        scrollViewCover.isUserInteractionEnabled = false
//        let pan = UIPanGestureRecognizer(target: self, action: #selector(panHandler(gesture:)))
//        scrollViewCover.addGestureRecognizer(pan)
    }
    
    override func viewDidLayoutSubviews() {
        
//        collectionView.layer.cornerRadius = 40
        collectionView.roundCorners(corners: .allCorners, radius: 40)
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
