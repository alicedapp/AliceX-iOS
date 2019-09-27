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
    
    let maximumPinItem = 5

    var pinList: [PinItem] = Array<PinItem>()
    {
        didSet {
            onMainThread {
                self.listVC?.updateIfNeeded()
                self.ball.updateIfNeeded()
                self.updateIfNeeded()
            }
        }
    }

    var floatVCList: Set<String> = Set<String>()
    
    var edgePan: UIScreenEdgePanGestureRecognizer?
    
    let ballSize: CGFloat = 60
    var isShown: Bool = false
    var shouldShow: Bool = false
    
    let coef: CGFloat = 1.2
    let floatMargin: CGFloat = 30.0
    let floatAreaR: CGFloat = Constant.SCREEN_WIDTH * 0.45
    
    var ball = FloatBall.instanceFromNib()
    var tempFloatVC: UIViewController?
    var floatVC: UIViewController?
    
    var listVC: PinListViewController?
    
    var currentPin: PinItem?
    var link: CADisplayLink?
    
    var floatArea = { () -> FloatPinView in
        let view = FloatPinView(frame: CGRect(x: Constant.SCREEN_WIDTH + 30,
                                              y: Constant.SCREEN_HEIGHT + 30,
                                              width: Constant.SCREEN_WIDTH * 0.45,
                                              height: Constant.SCREEN_WIDTH * 0.45))
        view.setStyle(style: .Default)
        return view
    }()
    
    var cancelFloatArea = { () -> FloatPinView in
        let view = FloatPinView(frame: CGRect(x: Constant.SCREEN_WIDTH,
                                              y: Constant.SCREEN_HEIGHT,
                                              width: Constant.SCREEN_WIDTH * 0.45,
                                              height: Constant.SCREEN_WIDTH * 0.45))
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(walletConnectDisconnect),
                                               name: .wallectConnectClientDisconnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(walletConnectDisconnect),
                                               name: .wallectConnectServerDisconnect, object: nil)
    }
    
    @objc func networkChange() {
        PinManager.shared.ball.imageView.image = UIImage.imageWithColor(color: WalletManager.currentNetwork.color)
    }
    
    @objc func newPendingTx(noti: Notification) {
        guard let userInfo = noti.userInfo, let item = userInfo["item"] else {
            return
        }
        addPinItem(item: item as! PinItem)
        listVC?.updateIfNeeded()
    }
    
    @objc func removePendingTx(noti: Notification) {
        guard let userInfo = noti.userInfo, let item = userInfo["item"] else {
            return
        }
        removePinItem(item: item as! PinItem)
        listVC?.updateIfNeeded()
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
    
    static func bringBallToFront() {
        UIApplication.shared.keyWindow?.bringSubviewToFront(PinManager.shared.ball)
    }
    
    static func addFloatVC(list: [String]) {
        for vc in list {
            PinManager.shared.floatVCList.insert(vc)
        }
    }
    
    func addPinItem(item: PinItem) {
        if pinList.count == maximumPinItem {
            pinList.removeFirst()
        }
        
        if !pinList.contains(item) {
            pinList.append(item)
        }
        
    }
    
    func removePinItem(item: PinItem) {
        guard let index = pinList.firstIndex(of: item) else {
            return
        }
        pinList.remove(at: index)
        
        if item.isWalletConnect {
            WCServerHelper.shared.disconnect(key: item.wcKey)
            WCClientHelper.shared.disconnect(key: item.wcKey)
        }
    }
    
    func updatePinItem(item: PinItem) {
        guard let index = pinList.firstIndex(of: item) else {
            return
        }
        pinList[index] = item
    }
}

extension PinManager: FloatBallDelegate {
    func floatBallDidClick(floatBall _: FloatBall) {
        if UIApplication.topViewController()?.nameOfClass == PinListViewController.nameOfClass {
            return
        }
        
        if listVC == nil {
            listVC = PinListViewController()
        }
        
        guard let listVC = self.listVC else {
            return
        }
        
        listVC.previousVC = UIApplication.topViewController()
        listVC.modalPresentationStyle = .overCurrentContext
        UIApplication.topViewController()?.present(listVC, animated: false, completion: nil)
    }

    func floatBallBeginMove(floatBall _: FloatBall) {
        
        UIApplication.shared.keyWindow?.addSubview(cancelFloatArea)
        UIApplication.shared.keyWindow?.bringSubviewToFront(ball)
        UIView.animate(withDuration: 0.5) {
            self.cancelFloatArea.frame = CGRect(x: Constant.SCREEN_WIDTH - self.floatAreaR,
                                                y: Constant.SCREEN_HEIGHT - self.floatAreaR,
                                                width: self.floatAreaR, height: self.floatAreaR)
        }
        
        let centerBall = UIApplication.shared.keyWindow?.convert(ball.center, to: cancelFloatArea)
        
        if ((pow(floatAreaR - centerBall!.x, 2)) + pow(floatAreaR - centerBall!.y, 2)) <= pow(floatAreaR, 2) {
            if !cancelFloatArea.highlight {
                cancelFloatArea.highlight = true
            }
        } else {
            if cancelFloatArea.highlight {
                cancelFloatArea.highlight = false
            }
        }
    }
    
    func floatBallEndMove(floatBall _: FloatBall) {
        
        if cancelFloatArea.highlight {
            tempFloatVC = nil
//            floatVC = nil
            currentPin = nil
            
            for item in pinList where item.isWalletConnect{
                WCServerHelper.shared.disconnect(key: item.wcKey)
                WCClientHelper.shared.disconnect(key: item.wcKey)
            }
            
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
