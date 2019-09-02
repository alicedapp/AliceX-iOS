//
//  PinManager.swift
//  AliceX
//
//  Created by lmcmz on 1/9/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation

class PinManager {
    static let shared = PinManager()
    let ballSize: CGFloat = 60

//    let listVC = PinListViewController()

    init() {}

    func show() {
        let ball = FloatBall.instanceFromNib()
        ball.frame = CGRect(x: Constant.SCREEN_WIDTH - ballSize - 15,
                            y: Constant.SCREEN_HEIGHT / 3,
                            width: ballSize,
                            height: ballSize)
        ball.delegate = self
        UIApplication.shared.keyWindow?.addSubview(ball)
    }

    func hide() {}
}

extension PinManager: FloatBallDelegate {
    func floatBallDidClick(floatBall _: FloatBall) {
        if UIApplication.topViewController()?.nameOfClass == PinListViewController.nameOfClass {
            return
        }
        let listVC = PinListViewController()
        listVC.modalPresentationStyle = .overCurrentContext
        UIApplication.topViewController()?.present(listVC, animated: false, completion: nil)
    }

    func floatBallBeginMove(floatBall _: FloatBall) {}

    func floatBallEndMove(floatBall _: FloatBall) {}
}
