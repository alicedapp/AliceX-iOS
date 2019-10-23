//
//  PayButtonView.swift
//  AliceX
//
//  Created by lmcmz on 23/9/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit

protocol PayButtonDelegate {
    func verifyAndSend()
}

class PayButtonView: UIControl {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var progressIndicator: RPCircularProgress!
    @IBOutlet var payButtonContainer: UIView!
    
    var process: Int = 0
    var cancelProcess: Int = 0
    var link: CADisplayLink?
    var toggle: Bool = false
    
    var buttonColor: UIColor = UIColor(hex: "333333")
    
    var delegate: PayButtonDelegate?
    
    class func instanceFromNib(title: String = "Hold to Send") -> PayButtonView {
        let view = UINib(nibName: nameOfClass, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! PayButtonView
        view.configure(title: title)
        return view
    }
    
    override func awakeFromNib() {
        layer.masksToBounds = false
        layer.cornerRadius = 20
        layer.shadowColor = UIColor(hex: "2060CB").cgColor
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize.zero
        layer.shadowOpacity = 0.3
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        longPressGesture.minimumPressDuration = 0
        addGestureRecognizer(longPressGesture)
        progressIndicator.updateProgress(0)
        
        if #available(iOS 12.0, *) {
            let userInterfaceStyle = traitCollection.userInterfaceStyle
            switch userInterfaceStyle {
            case .dark:
                buttonColor = UIColor(hex: "C0C0C0")
                progressIndicator.progressTintColor = .black
            default:
                buttonColor = UIColor(hex: "333333")
                progressIndicator.progressTintColor = .white
            }
        }
    }

    func configure(title: String) {
        titleLabel.text = title
    }
    
    @objc func longPress(gesture: UILongPressGestureRecognizer) {
        
        if toggle {
            return
        }
        
        switch gesture.state {
        case .began:
            link = CADisplayLink(target: self, selector: #selector(progressUpdate))
            link!.add(to: .main, forMode: .common)
            
            UIView.animate(withDuration: 0.3) {
                self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }
            
        case .changed:
            break
        case .cancelled, .ended, .failed:
            
            UIView.animate(withDuration: 0.3) {
                self.transform = CGAffineTransform.identity
                self.payButtonContainer.backgroundColor? = self.buttonColor
            }
            link!.invalidate()
            progressIndicator.updateProgress(0)
            toggle = false
            process = 0

        default:
//            if link != nil {
//                link!.invalidate()
//            }
            break
        }
    }
    
    @objc func progressUpdate() {
        process += 1
        var precentage = (Double(process) / 80)
        
        if precentage >= 1 {
            precentage = 1
        }
        
        progressIndicator.updateProgress(CGFloat(precentage))
        payButtonContainer.backgroundColor? = UIColor.interpolate(between: buttonColor,
                                                                  and: WalletManager.currentNetwork.color,
                                                                  percent: CGFloat(precentage))!
        
        if precentage < 1 {
            return
        }

        if toggle == false {
            
            toggle = true
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
            if link != nil {
                link!.invalidate()
            }
            
            delegate?.verifyAndSend()
        }
    }
    
    func showLoading() {
        isUserInteractionEnabled = false
        if !toggle {
            return
        }
        
        progressIndicator.updateProgress(0.3)
        progressIndicator.enableIndeterminate()
        link!.invalidate()
        
        UIView.animate(withDuration: 0.3) {
            self.transform = CGAffineTransform.identity
//            self.payButtonContainer.backgroundColor? = UIColor(hex: "333333")
        }
    }
    
    func failed() {
        UIView.animate(withDuration: 0.3) {
            self.payButtonContainer.backgroundColor? = self.buttonColor
        }
        isUserInteractionEnabled = true
        progressIndicator.enableIndeterminate(false, completion: nil)
        progressIndicator.updateProgress(0)
        toggle = false
        process = 0
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if #available(iOS 12.0, *) {
            guard previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle else {
                return
            }
            
            let userInterfaceStyle = traitCollection.userInterfaceStyle
            switch userInterfaceStyle {
            case .dark:
                buttonColor = UIColor(hex: "C0C0C0")
                progressIndicator.progressTintColor = .black
            default:
                buttonColor = UIColor(hex: "333333")
                progressIndicator.progressTintColor = .white
            }
        }
    }
    
}
