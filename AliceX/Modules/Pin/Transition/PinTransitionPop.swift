//
//  PinTransitionPop.swift
//  AliceX
//
//  Created by lmcmz on 3/9/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation

class PinTransitionPop: NSObject, UIViewControllerAnimatedTransitioning {
    var transitionContext: UIViewControllerContextTransitioning?

    let duration = 0.5

    lazy var coverView: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.black
        view.alpha = 0
        return view
    }()

    func transitionDuration(using _: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to),
            let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to)
        else {
            return
        }
        self.transitionContext = transitionContext

        let contView = transitionContext.containerView
        contView.addSubview(toView)
        contView.addSubview(fromView)

        fromVC.view.addSubview(coverView)

        let maskStartBP = UIBezierPath(roundedRect: PinManager.shared.ball.frame, cornerRadius: 30)
        let maskFinalBP = UIBezierPath(roundedRect: UIScreen.main.bounds, cornerRadius: 30)

        let maskLayer = CAShapeLayer()
        maskLayer.path = maskStartBP.cgPath
        fromView.layer.mask = maskLayer

        let maskLayerAnimation = CABasicAnimation(keyPath: "path")
        maskLayerAnimation.fromValue = maskFinalBP.cgPath
        maskLayerAnimation.toValue = maskStartBP.cgPath
        maskLayerAnimation.duration = duration
        maskLayerAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        maskLayerAnimation.delegate = self
        maskLayer.add(maskLayerAnimation, forKey: "path")

        UIView.animate(withDuration: duration) {
            self.coverView.alpha = 0.5
        }
    }
}

extension PinTransitionPop: CAAnimationDelegate {
    func animationDidStop(_: CAAnimation, finished _: Bool) {
        transitionContext?.completeTransition(true)
        transitionContext?.viewController(forKey: .from)?.view.layer.mask = nil
        transitionContext?.viewController(forKey: .to)?.view.layer.mask = nil
        coverView.removeFromSuperview()
    }
}
