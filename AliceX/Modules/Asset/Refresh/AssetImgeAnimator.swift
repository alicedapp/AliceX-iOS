//
//  AssetAnimateImgeAnimator.swift
//  AliceX
//
//  Created by lmcmz on 1/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import ESPullToRefresh

class AssetImgeAnimator: UIView, ESRefreshProtocol, ESRefreshAnimatorProtocol  {
    
    public var insets: UIEdgeInsets = UIEdgeInsets.zero
    public var view: UIView { return self }
    public var duration: TimeInterval = 0.3
    public var trigger: CGFloat = 80.0
    public var executeIncremental: CGFloat = 80.0
    public var state: ESRefreshViewState = .pullToRefresh
    
    private let imageView: UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = UIImage.init(named: "Money_Face_0")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageView)
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func refreshAnimationBegin(view: ESRefreshComponent) {
        imageView.center = self.center
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
            self.imageView.frame = CGRect.init(x: (self.bounds.size.width - 80.0) / 2.0,
                                               y: self.bounds.size.height - 80.0,
                                           width: 80.0,
                                          height: 80.0)
            }, completion: { (_) in
                var images = [UIImage]()
                for idx in 17 ... 57 {
                    if let aImage = UIImage(named: "Money_Face_\(idx)-squashed") {
                        images.append(aImage)
                    }
                }
                self.imageView.animationDuration = 2.5
                self.imageView.animationRepeatCount = 0
                self.imageView.animationImages = images
                self.imageView.startAnimating()
        })
    }
    
    public func refreshAnimationEnd(view: ESRefreshComponent) {
        imageView.stopAnimating()
        imageView.image = UIImage.init(named: "Money_Face_0")
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
            self.refresh(view: view, progressDidChange: 0.0)
//            self.imageView.alpha = 0.0
//            self.imageView.frame = CGRect.init(x: (self.bounds.size.width) / 2.0,
//                                          y: self.bounds.size.height,
//                                          width: 50.0,
//                                          height: 50.0)
        }, completion: { (finished) in
//            self.imageView.alpha = 1.0
        })
    }
    
    public func refresh(view: ESRefreshComponent, progressDidChange progress: CGFloat) {
        let p = max(0.0, min(1.0, progress))
        imageView.frame = CGRect.init(x: (self.bounds.size.width - 80.0 * p) / 2.0,
                                      y: self.bounds.size.height - 80.0 * p,
                                      width: 80.0 * p,
                                      height: 80.0 * p)
    }
    
    public func refresh(view: ESRefreshComponent, stateDidChange state: ESRefreshViewState) {
        guard self.state != state else {
            return
        }
        self.state = state
        
        switch state {
        case .pullToRefresh:
            var images = [UIImage]()
            for idx in 0 ... 16 {
                if let aImage = UIImage(named: "Money_Face_\((16 - idx))") {
                    images.append(aImage)
                }
            }
            imageView.animationDuration = 0.2
            imageView.animationRepeatCount = 1
            imageView.animationImages = images
            imageView.image = UIImage.init(named: "Money_Face_0")
            imageView.startAnimating()
        case .releaseToRefresh:
            var images = [UIImage]()
            for idx in 0 ... 16 {
                if let aImage = UIImage(named: "Money_Face_\(idx)") {
                    images.append(aImage)
                }
            }
            imageView.animationDuration = 0.2
            imageView.animationRepeatCount = 1
            imageView.animationImages = images
            imageView.image = UIImage.init(named: "Money_Face_16")
            imageView.startAnimating()
        default:
            break
        }
    }
    
}

