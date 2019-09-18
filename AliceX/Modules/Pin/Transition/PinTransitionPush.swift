//
//  PinTransition.swift
//  AliceX
//
//  Created by lmcmz on 2/9/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation

class PinTransitionPush: NSObject, UIViewControllerAnimatedTransitioning {
    static var pushCellFrame: CGRect?

    let duration = 0.5

    var transitionContext: UIViewControllerContextTransitioning?
    lazy var coverView: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.black
        view.alpha = 0.5
        return view
    }()

    func transitionDuration(using _: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
        else {
            return
        }
        self.transitionContext = transitionContext

        let contView = transitionContext.containerView
        contView.addSubview(fromVC.view)
        contView.addSubview(toVC.view)

        fromVC.view.addSubview(coverView)

        let maskStartBP = UIBezierPath(roundedRect: PinTransitionPush.pushCellFrame!, cornerRadius: 30)
//            UIBezierPath(roundedRect: PinTransitionPush.pushCellFrame!,
//                                       byRoundingCorners: [.topLeft, .bottomLeft],
//                                       cornerRadii: CGSize(width: PinTransitionPush.pushCellFrame!.height / 2,
//                                                           height: PinTransitionPush.pushCellFrame!.height / 2))
        let maskFinalBP = UIBezierPath(roundedRect: UIScreen.main.bounds, cornerRadius: 30)

        let maskLayer = CAShapeLayer()
        maskLayer.path = maskStartBP.cgPath
        toVC.view.layer.mask = maskLayer

        let maskLayerAnimation = CABasicAnimation(keyPath: "path")
        maskLayerAnimation.fromValue = maskStartBP.cgPath
        maskLayerAnimation.toValue = maskFinalBP.cgPath
        maskLayerAnimation.duration = duration
        maskLayerAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        maskLayerAnimation.delegate = self

        maskLayer.add(maskLayerAnimation, forKey: "path")

        UIApplication.shared.keyWindow?.bringSubviewToFront(PinManager.shared.ball)

//        UIView.animate(withDuration: duration) {
//            self.coverView.alpha = 0
//        }

        UIView.animate(withDuration: duration - 0.01, delay: 0, options: [], animations: {
            self.coverView.alpha = 0
        }) { _ in
            contView.subviews.first?.removeFromSuperview()
        }
    }
}

extension PinTransitionPush: CAAnimationDelegate {
    func animationDidStop(_: CAAnimation, finished _: Bool) {
        transitionContext?.completeTransition(true)
        transitionContext?.viewController(forKey: .from)?.view.layer.mask = nil
        transitionContext?.viewController(forKey: .to)?.view.layer.mask = nil
        coverView.removeFromSuperview()
    }
}
