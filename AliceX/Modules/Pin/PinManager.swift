//
//  PinManager.swift
//  AliceX
//
//  Created by lmcmz on 1/9/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation

class PinManager: NSObject {
    static let shared = PinManager()

    var pinList: Set<PinItem> = Set<PinItem>() {
        didSet {
            ball.updateIfNeeded()
            updateIfNeeded()
        }
    }
    var floatVCList: Set<String> = Set<String>()
    
    var edgePan: UIScreenEdgePanGestureRecognizer?
    
    let ballSize: CGFloat = 60
    var isShown: Bool = false
    var shouldShow: Bool = false
//    {
//        didSet {
//            
//        }
//    }
    
    let coef: CGFloat = 1.2
    let floatMargin: CGFloat = 30.0
    let floatAreaR: CGFloat = Constant.SCREEN_WIDTH * 0.45
    
    var ball = FloatBall.instanceFromNib()
    var tempFloatVC: UIViewController?
    var floatVC: UIViewController?
    var currentPin: PinItem?
    var link: CADisplayLink?
    
    lazy var floatArea = { () -> FloatPinView in
        let view = FloatPinView(frame: CGRect(x: Constant.SCREEN_WIDTH + self.floatMargin,
                                              y: Constant.SCREEN_HEIGHT + self.floatMargin,
                                              width: self.floatAreaR, height: self.floatAreaR))
        view.setStyle(style: .Default)
        return view
    }()
    
    lazy var cancelFloatArea = { () -> FloatPinView in
        let view = FloatPinView(frame: CGRect(x: Constant.SCREEN_WIDTH,
                                              y: Constant.SCREEN_HEIGHT,
                                              width: self.floatAreaR, height: self.floatAreaR))
        view.setStyle(style: .Cancel)
        return view
    }()

    override init() {
        super.init()
    
        ball.frame = CGRect(x: Constant.SCREEN_WIDTH - ballSize - 15,
                                       y: Constant.SCREEN_HEIGHT / 3,
                                       width: ballSize,
                                       height: ballSize)
        ball.delegate = self

//        interactivePopGestureRecognizer.delegate
        UIApplication.topNavigationController()?.delegate = self
        UIApplication.topNavigationController()?.interactivePopGestureRecognizer?.delegate = self 
        
        NotificationCenter.default.addObserver(self, selector: #selector(newPendingTx), name: .newPendingTransaction, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removePendingTx), name: .removePendingTransaction, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(networkChange), name: .networkChange, object: nil)
    }
    
    @objc func networkChange() {
        PinManager.shared.ball.imageView.image = UIImage.imageWithColor(color: WalletManager.currentNetwork.color)
    }
    
    @objc func newPendingTx(noti: Notification) {
        guard let userInfo = noti.userInfo, let item = userInfo["item"] else {
            return
        }
        
        pinList.insert(item as! PinItem)
    }
    
    @objc func removePendingTx(noti: Notification) {
        guard let userInfo = noti.userInfo, let item = userInfo["item"] else {
            return
        }
        pinList.remove(item as! PinItem)
    }

    func updateIfNeeded() {
        if PinManager.shared.pinList.count != 0 {
            show()
            return
        }
        hide()
    }
    
    func show() {
        
        if PinManager.shared.isShown {
            return
        }
        
        if PinManager.shared.pinList.count == 0 {
            return
        }
        
        UIApplication.shared.keyWindow?.addSubview(PinManager.shared.ball)
        
        PinManager.shared.ball.transform = CGAffineTransform(translationX: 100, y: 0)
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
            PinManager.shared.ball.transform = CGAffineTransform.identity
        }) { (_) in
            PinManager.shared.isShown = true
        }
    }

    func hide() {
        if !PinManager.shared.isShown {
            return
        }
        
        if PinManager.shared.pinList.count != 0 {
            return
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
            PinManager.shared.ball.transform = CGAffineTransform(translationX: 100, y: 0)
        }) { _ in
            PinManager.shared.ball.transform = CGAffineTransform.identity
            PinManager.shared.ball.removeFromSuperview()
            PinManager.shared.isShown = false
        }
    }
    
    static func addFloatVC(list: [String]) {
        for vc in list {
            PinManager.shared.floatVCList.insert(vc)
        }
    }
    
    func addPinItem(item: PinItem) {
        pinList.insert(item)
    }
    
    func removePinItem(item: PinItem) {
        pinList.remove(item)
    }
}

extension PinManager: FloatBallDelegate {
    func floatBallDidClick(floatBall _: FloatBall) {
        if UIApplication.topViewController()?.nameOfClass == PinListViewController.nameOfClass {
            return
        }
        
        let listVC = PinListViewController()
        listVC.previousVC = UIApplication.topViewController()
        listVC.modalPresentationStyle = .overCurrentContext
        UIApplication.topViewController()?.present(listVC, animated: false, completion: nil)
    }

    func floatBallBeginMove(floatBall _: FloatBall) {
        
        UIApplication.shared.keyWindow?.insertSubview(cancelFloatArea, at: 1)
        UIView.animate(withDuration: 0.5) {
            self.cancelFloatArea.frame = CGRect(x: Constant.SCREEN_WIDTH - self.floatAreaR,
                                                y: Constant.SCREEN_HEIGHT - self.floatAreaR,
                                                width: self.floatAreaR, height: self.floatAreaR)
        }
        
        let centerBall = UIApplication.shared.keyWindow?.convert(ball.center, to: cancelFloatArea)
        
        if ((pow(floatAreaR - centerBall!.x, 2)) + pow(floatAreaR - centerBall!.y, 2)) <= pow(floatAreaR, 2) {
            if !cancelFloatArea.highlight {
                cancelFloatArea.setHighlight(highlight: true)
            }
        } else {
            if cancelFloatArea.highlight {
                cancelFloatArea.setHighlight(highlight: false)
            }
        }
    }
    
    func floatBallEndMove(floatBall _: FloatBall) {
        
        if cancelFloatArea.highlight {
            tempFloatVC = nil
//            floatVC = nil
            currentPin = nil
            pinList.removeAll()
//            ball = nil;
            
            // Reset pin ball to init position
            UIView.animate(withDuration: 0, delay: 0.5, options: [], animations: {
                self.ball.transform = CGAffineTransform.identity
                self.ball.frame = CGRect(x: Constant.SCREEN_WIDTH - self.ballSize - 15,
                                         y: Constant.SCREEN_HEIGHT / 3,
                                         width: self.ballSize,
                                         height: self.ballSize)
            }, completion: nil)
        }
        
        cancelFloatArea.highlight = false
        
        UIView.animate(withDuration: 0.5, animations: {
            self.cancelFloatArea.frame = CGRect(x: Constant.SCREEN_WIDTH,
                                                y: Constant.SCREEN_HEIGHT,
                                                width: self.floatAreaR,
                                                height: self.floatAreaR)
        }) { (_) in
            self.cancelFloatArea.removeFromSuperview()
        }
    }
}
