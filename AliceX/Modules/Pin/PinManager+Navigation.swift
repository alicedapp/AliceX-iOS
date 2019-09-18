//
//  PinManager+Navigation.swift
//  AliceX
//
//  Created by lmcmz on 18/9/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation

extension PinManager: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if UIApplication.topNavigationController()!.viewControllers.count > 1 {
            beginScreenEdgePanBack(gestureRecognizer: gestureRecognizer)
            return true
        }
        return false
    }
    
    func beginScreenEdgePanBack(gestureRecognizer: UIGestureRecognizer) {
        
        if floatVCList.contains(UIApplication.topViewController()!.nameOfClass) {
            edgePan = (gestureRecognizer as! UIScreenEdgePanGestureRecognizer)
            link = CADisplayLink(target: self, selector: #selector(panBack))
            link!.add(to: .main, forMode: .common)
            UIApplication.shared.keyWindow?.addSubview(floatArea)
            tempFloatVC = UIApplication.topViewController()
        }
    }
    
    @objc func panBack(link: CADisplayLink) {
        switch edgePan!.state {
        case .changed:
            let tPoint = edgePan?.translation(in: UIApplication.shared.keyWindow)
            let x = max(Constant.SCREEN_WIDTH + floatMargin - coef*tPoint!.x, Constant.SCREEN_WIDTH - floatAreaR)
            let y = max(Constant.SCREEN_HEIGHT + floatMargin - coef*tPoint!.x, Constant.SCREEN_HEIGHT - floatAreaR)
            let rect = CGRect(x: x, y: y, width: floatAreaR, height: floatAreaR)
            self.floatArea.frame = rect
            
            let touchPoint = UIApplication.shared.keyWindow?.convert((edgePan?.location(in: UIApplication.shared.keyWindow))!,
                                                                     to: floatArea)
            if (touchPoint!.x > 0 && touchPoint!.y > 0) {
                if (pow(floatAreaR - touchPoint!.x, 2) + pow(floatAreaR - touchPoint!.y, 2)) <= pow(floatAreaR, 2) {
                    shouldShow = true
                    floatArea.setHighlight(highlight: true)
                    
                } else {
                    if shouldShow {
                        shouldShow = false
                        floatArea.setHighlight(highlight: false)
                    }
                }
            } else {
                if shouldShow {
                    shouldShow = false
                    floatArea.setHighlight(highlight: false)
                }
            }
        case .possible:
            UIView.animate(withDuration: 0.5, animations: {
                self.floatArea.frame = CGRect(x: Constant.SCREEN_WIDTH, y: Constant.SCREEN_HEIGHT,
                                              width: self.floatAreaR, height: self.floatAreaR)
            }) { (_) in
                self.floatArea.removeFromSuperview()
                self.link!.invalidate()
//                self.link = nil
                if !self.shouldShow {
                    return
                }
//                self.ball.alpha = 1
                
                self.floatVC = self.tempFloatVC
                if let vc = self.floatVC as? PinDelegate {
                    self.pinList.insert(vc.pinItem())
                }
                self.show()
            }
        default:
            break
        }
    }
}

extension PinManager: UINavigationControllerDelegate {
    func navigationController(_: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {

            
            if pinList.count == 0 {
                return nil
            }
            
            guard let pin = currentPin else {
                return nil
            }
            
            switch operation {
            case .push:
                if toVC != pin.vc {
                    return nil
                }
                return PinTransitionPush()
            case .pop:
                if fromVC != pin.vc {
                    return nil
                }
                return PinTransitionPop()
            default:
                return nil
            }
    }
}
