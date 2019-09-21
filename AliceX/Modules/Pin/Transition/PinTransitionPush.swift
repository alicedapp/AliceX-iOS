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
            let toView = transitionContext.view(forKey: .to),
            let snapshot = toView.snapshotView(afterScreenUpdates: true)
        else {
            return
        }
        self.transitionContext = transitionContext
        
        let contView = transitionContext.containerView
//        contView.addSubview(fromView)
        contView.addSubview(toView)

        fromView.addSubview(coverView)

        let maskStartBP = UIBezierPath(roundedRect: PinTransitionPush.pushCellFrame!, cornerRadius: 30)
//            UIBezierPath(roundedRect: PinTransitionPush.pushCellFrame!,
//                                       byRoundingCorners: [.topLeft, .bottomLeft],
//                                       cornerRadii: CGSize(width: PinTransitionPush.pushCellFrame!.height / 2,
//                                                           height: PinTransitionPush.pushCellFrame!.height / 2))
        let maskFinalBP = UIBezierPath(roundedRect: UIScreen.main.bounds, cornerRadius: 30)

        let maskLayer = CAShapeLayer()
        maskLayer.path = maskFinalBP.cgPath
        toView.layer.mask = maskLayer

        let maskLayerAnimation = CABasicAnimation(keyPath: "path")
        maskLayerAnimation.fromValue = maskStartBP.cgPath
        maskLayerAnimation.toValue = maskFinalBP.cgPath
        maskLayerAnimation.duration = duration
        maskLayerAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        maskLayerAnimation.delegate = self

        maskLayer.add(maskLayerAnimation, forKey: "path")

        UIApplication.shared.keyWindow?.bringSubviewToFront(PinManager.shared.ball)

        UIView.animate(withDuration: duration) {
            self.coverView.alpha = 0.5
        }

//        UIView.animate(withDuration: duration - 0.5, delay: 0, options: [], animations: {
//            self.coverView.alpha = 0.5
//        }) { _ in
//            contView.subviews.first?.removeFromSuperview()
//        }
    }
}

extension PinTransitionPush: CAAnimationDelegate {
    
    func animationDidStart(_ anim: CAAnimation) {
//        UIView.animate(withDuration: duration - 0.05, delay: 0, options: [], animations: {
//            self.coverView.alpha = 0
//        }) { _ in
//            self.transitionContext?.containerView.subviews.first?.removeFromSuperview()
//        }
    }
    
    func animationDidStop(_: CAAnimation, finished _: Bool) {
        transitionContext?.completeTransition(true)
        transitionContext?.viewController(forKey: .from)?.view.layer.mask = nil
        transitionContext?.viewController(forKey: .to)?.view.layer.mask = nil
        coverView.removeFromSuperview()
    }
}
