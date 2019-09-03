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

    var pinList: Set<PinItem>?

    let ballSize: CGFloat = 60

    static let ball = FloatBall.instanceFromNib()

    override init() {
        super.init()
        PinManager.ball.frame = CGRect(x: Constant.SCREEN_WIDTH - ballSize - 15,
                                       y: Constant.SCREEN_HEIGHT / 3,
                                       width: ballSize,
                                       height: ballSize)
        PinManager.ball.delegate = self

//        interactivePopGestureRecognizer.delegate
        UIApplication.topViewController()?.navigationController?.delegate = self
    }

    static func show() {
        UIApplication.shared.keyWindow?.addSubview(ball)
//        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
//
//        }) { (_) in
//
//        }
    }

    static func hide() {
//        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
//            PinManager.ball.transform = CGAffineTransform(scaleX: 80, y: 0)
//        }) { _ in
//            PinManager.ball.transform = CGAffineTransform.identity
//        }

        PinManager.ball.removeFromSuperview()
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
