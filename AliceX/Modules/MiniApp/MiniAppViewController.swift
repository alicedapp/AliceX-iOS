//
//  MiniAppViewController.swift
//  AliceX
//
//  Created by lmcmz on 12/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit
import Hero

class MiniAppViewController: BaseViewController {
    
    @IBOutlet var container: UIView!
    @IBOutlet var naviContainer: UIView!
    @IBOutlet var rnContainer: UIView!
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var scrollViewCover: UIView!
    @IBOutlet var backIndicator: UIImageView!
    @IBOutlet var backButton: UIView!
    
    var overPlay: Bool = false
    var percentage: CGFloat = 0.0
    
    var isTriggle: Bool = false
    
    lazy var cameraVC: CameraContainerViewController = { () -> CameraContainerViewController in
        let vc = CameraContainerViewController()
//        vc.view.frame = CGRect(x: 0, y: 0, width: Constant.SCREEN_WIDTH, height: Constant.SCREEN_HEIGHT)
        return vc
    }()
    
    var naviColor: UIColor = .white
//    let rnColor: UIColor = .white
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let rnView = RCTRootView(bridge: AppDelegate.rnBridge(),
                                       moduleName: AliceRN.alice.rawValue,
                                       initialProperties: nil) else {
            return
        }
        rnContainer.insertSubview(rnView, belowSubview: scrollViewCover)
        rnView.fillSuperview()
        
        view.backgroundColor = .clear
        scrollView.delegate = self
        scrollView.alwaysBounceVertical = true
        
        addChild(cameraVC)
        view.insertSubview(cameraVC.view, belowSubview: naviContainer)
//        constrainViewEqual(hfuolderView, view: childController.view)
        cameraVC.view.fillSuperview()
        cameraVC.didMove(toParent: self)
        cameraVC.willMove(toParent: self)
//        cameraVC.view.backgroundColor = 
        cameraVC.view.fillSuperview()
//        cameraVC.view.center = view.center
//        cameraVC.view.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        
        //cameraVC.view.transform = CGAffineTransform.init(scaleX: 0.3, y: 0.3)
        naviColor = naviContainer.backgroundColor!
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(coverClick))
        scrollViewCover.addGestureRecognizer(tap)
        
//        backButton.transform = CGAffineTransform.init(translationX: 0, y: 30)
        backIndicator.transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi / 2))
    }
    
    @objc func coverClick() {
        
        isTriggle = false
        
        self.percentage = 0.0
        
        UIView.animate(withDuration: 0.3, animations: {
            self.scrollViewCover.alpha = 0.0
            self.scrollViewCover.isUserInteractionEnabled = false
            self.cameraVC.view.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.3)
            
            self.naviContainer.transform = CGAffineTransform.identity
            self.naviContainer.backgroundColor = self.naviColor
            
            self.scrollView.frame = CGRect(x: 0, y: 104,
                                           width: Constant.SCREEN_WIDTH,
                                           height:Constant.SCREEN_HEIGHT - 104)
            self.scrollView.roundCorners(corners: [.topLeft, .topRight], radius: 0)
            self.rnContainer.roundCorners(corners: [.topLeft, .topRight], radius: 0)
            self.naviContainer.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 0)
            
            self.cameraVC.blurView.alpha = 1
            
        }) { (_) in
//            self.scrollView.isUserInteractionEnabled = true
            self.scrollView.isScrollEnabled = true
            self.cameraVC.disableCamera()
        }
        
        view.layoutIfNeeded()
        
    }
    
    @IBAction func browserButtonClick() {
        let vc = BrowserWrapperViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func cameraButtonClick() {
        let vc = QRCodeReaderViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    @available(iOS 12.0, *)
    override func themeDidChange(style: UIUserInterfaceStyle) {        
        naviColor = style == .dark ? .black : .white
    }
}

extension MiniAppViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let y = scrollView.contentOffset.y
        
        if y > 0 {
            scrollView.backgroundColor = naviColor
            scrollView.bounces = false
            return
        }
        
        scrollView.bounces = true
        scrollView.backgroundColor = .clear
        
        if isTriggle {
            return
        }
        
        let percentage = min( max(-y / 120, 0), 1.0)
        let slowPercentage = min( max(-y / 250, 0), 1.0)
        
        if y < -120 {
            if !overPlay {
                UIImpactFeedbackGenerator.init(style: .light).impactOccurred()
                overPlay = true
            }
        } else {
            overPlay = false
        }
        
        if percentage > 1 {
            return
        }
        
        self.percentage = percentage
        
        print(percentage)
        
        updateCameraVC(slowPercentage: slowPercentage)
        updateStyle(slowPercentage: slowPercentage)
    }
    
    func updateStyle(slowPercentage: CGFloat) {
//        let color = self.naviColor.interpolate(between: .brown, percent: self.percentage)
//        rnContainer.backgroundColor = color
        rnContainer.roundCorners(corners: [.topLeft, .topRight], radius: 40*self.percentage)
        
        let naviColor = self.naviColor.toColor(.clear, percentage: self.percentage*100)
        naviContainer.backgroundColor = naviColor
        naviContainer.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 40*self.percentage)
        naviContainer.transform = CGAffineTransform.init(translationX: 0, y: -120*self.percentage)
        
        scrollViewCover.alpha = percentage
    }

    func updateCameraVC(slowPercentage: CGFloat) {
        cameraVC.view.transform = CGAffineTransform.init(scaleX: 1.2 - 0.2 * self.percentage,
                                                         y: 1.3 - 0.3 * self.percentage)
        
        cameraVC.blurView.alpha = 1 - slowPercentage
//        let bounds = cameraVC.view.bounds
//        cameraVC.view.frame = CGRect(x: (bounds.size.width - Constant.SCREEN_WIDTH * percentage) / 2.0,
//                                     y: bounds.size.height - Constant.SCREEN_HEIGHT * percentage,
//                                     width: Constant.SCREEN_WIDTH * percentage,
//                                     height: Constant.SCREEN_HEIGHT * percentage)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let offsetY = scrollView.contentOffset.y
        
        if offsetY < -120 {
            
            isTriggle = true
            
            self.percentage = 1.0
            
            UIView.animate(withDuration: 0.3, animations: {
                self.scrollViewCover.alpha = 1.0
                self.scrollViewCover.isUserInteractionEnabled = true
                self.cameraVC.view.transform = CGAffineTransform.identity
                
                self.scrollView.frame = CGRect(x: 0, y: Constant.SCREEN_HEIGHT - 120,
                                               width: self.scrollView.bounds.width,
                                               height: self.scrollView.bounds.height)
                self.scrollView.roundCorners(corners: [.topLeft, .topRight], radius: 40)
                self.naviContainer.transform = CGAffineTransform.init(translationX: 0, y: -120)
//                self.backButton.transform = CGAffineTransform.identity
//                self.backIndicator.transform = CGAffineTransform.identity
            }) { (_) in
//                self.scrollView.isUserInteractionEnabled = false
                self.scrollView.isScrollEnabled = false
                self.cameraVC.activeCamera()
                self.cameraVC.blurView.alpha = 0
            }
            view.layoutIfNeeded()
        }
        
    }
}
