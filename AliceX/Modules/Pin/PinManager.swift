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

    var pinList: Set<PinItem> = Set<PinItem>()
    let ballSize: CGFloat = 60
    var isShown: Bool = false
    static let ball = FloatBall.instanceFromNib()

    override init() {
        super.init()
        PinManager.ball.frame = CGRect(x: Constant.SCREEN_WIDTH - ballSize - 15,
                                       y: Constant.SCREEN_HEIGHT / 3,
                                       width: ballSize,
                                       height: ballSize)
        PinManager.ball.delegate = self

//        interactivePopGestureRecognizer.delegate
//        UIApplication.topViewController()?.navigationController?.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(newPendingTx), name: .newPendingTransaction, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removePendingTx), name: .removePendingTransaction, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(networkChange), name: .networkChange, object: nil)
    }
    
    @objc func networkChange() {
        PinManager.ball.imageView.image = UIImage.imageWithColor(color: WalletManager.currentNetwork.color)
    }
    
    @objc func newPendingTx(noti: Notification) {
        guard let userInfo = noti.userInfo, let item = userInfo["item"] else {
            return
        }
        
        pinList.insert(item as! PinItem)
        PinManager.show()
    }
    
    @objc func removePendingTx(noti: Notification) {
        guard let userInfo = noti.userInfo, let item = userInfo["item"] else {
            return
        }
        pinList.remove(item as! PinItem)
        PinManager.hide()
    }

    static func show() {
        
        if PinManager.shared.isShown {
            return
        }
        
        if PinManager.shared.pinList.count == 0 {
            return
        }
        
        UIApplication.shared.keyWindow?.addSubview(ball)
        
        PinManager.ball.transform = CGAffineTransform(translationX: 100, y: 0)
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
            PinManager.ball.transform = CGAffineTransform.identity
        }) { (_) in
            PinManager.shared.isShown = true
        }
    }

    static func hide() {
        if !PinManager.shared.isShown {
            return
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
            PinManager.ball.transform = CGAffineTransform(translationX: 100, y: 0)
        }) { _ in
            PinManager.ball.transform = CGAffineTransform.identity
            PinManager.ball.removeFromSuperview()
            PinManager.shared.isShown = false
        }
    }
}

extension PinManager: FloatBallDelegate {
    func floatBallDidClick(floatBall _: FloatBall) {
        if UIApplication.topViewController()?.nameOfClass == PinListViewController.nameOfClass {
            return
        }
//        PinManager.hide()
        let listVC = PinListViewController()
        
        listVC.previousVC = UIApplication.topViewController()
        listVC.modalPresentationStyle = .overCurrentContext
        UIApplication.topViewController()?.present(listVC, animated: false, completion: nil)
    }

    func floatBallBeginMove(floatBall _: FloatBall) {}

    func floatBallEndMove(floatBall _: FloatBall) {}
}

extension PinManager: UINavigationControllerDelegate {
    func navigationController(_: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from _: UIViewController,
                              to _: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            return PinTransitionPush()
        case .pop:
            return PinTransitionPop()
        default:
            return nil
        }
    }
}
