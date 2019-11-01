//
//  AssetLoadingAnimator.swift
//  AliceX
//
//  Created by lmcmz on 31/10/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

//import Foundation
//import ESPullToRefresh
//import Lottie
//
//public class AssetLoadingAnimator: UIView, ESRefreshProtocol, ESRefreshAnimatorProtocol {
//
//    public var insets: UIEdgeInsets = UIEdgeInsets.zero
//    public var view: UIView { return self }
//    public var duration: TimeInterval = 0.3
//    public var trigger: CGFloat = 80.0
//    public var executeIncremental: CGFloat = 80.0
//    public var state: ESRefreshViewState = .pullToRefresh
//
//    private let animationView: AnimationView = {
//
//        let animation = Animation.named("test")
//
//        let view = AnimationView()
//        view.animation = animation
//        view.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
//        view.contentMode = .scaleAspectFill
////        view.animationSpeed = 2
//        return view
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.addSubview(animationView)
//        animationView.center = self.center
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    public func refreshAnimationBegin(view: ESRefreshComponent) {
//        animationView.center = self.center
//        animationView.play()
//    }
//
//    public func refreshAnimationEnd(view: ESRefreshComponent) {
//        animationView.stop()
//    }
//
//    public func refresh(view: ESRefreshComponent, progressDidChange progress: CGFloat) {
////        let p = min(1.0, max(0.0, progress))
////        animationView.currentProgress = p
//    }
//
//    public func refresh(view: ESRefreshComponent, stateDidChange state: ESRefreshViewState) {
//        guard self.state != state else {
//            return
//        }
//        self.state = state
//
//        switch state {
//        case .pullToRefresh:
//            animationView.play()
//        case .releaseToRefresh:
//            animationView.loopMode = .loop
//            animationView.play()
//        default:
//            break
//        }
//    }
//
//}
