//
//  FloatPinView.swift
//  AliceX
//
//  Created by lmcmz on 1/9/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import UIKit

enum FloatPinViewStyle: Int {
    case Default
    case Cancel
}

class FloatPinView: UIView {
    var title: NSString
    var radius_0: CGFloat
    var radius_1: CGFloat
    var kCoef: CGFloat

    var isImapcted: Bool = false

    var highlight: Bool {
        didSet {
            setNeedsDisplay()
            if highlight {
                if !isImapcted {
                    let impactLight = UIImpactFeedbackGenerator(style: .medium)
                    impactLight.impactOccurred()
                    isImapcted = true
                }
            } else {
                isImapcted = false
            }
        }
    }

    var style: FloatPinViewStyle
//    {
//        set {
//            self.style = newValue
//            switch style {
//            case .Default:
//                backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.8)
//                title = highlight ? "Release To Pin" : "Drag Here To Pin";
//            case .Cancel:
//                backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.8)
//                title = highlight ? "Release To Unpin" : "Drag Here To Unpin"
//            }
//        }
//        get {
//            return self.style
//        }
//    }

    override init(frame: CGRect) {
        title = "Drag Here To Pin"
        radius_0 = 20
        radius_1 = 12
        kCoef = 0.95
        style = .Default
        highlight = false
        super.init(frame: frame)
        backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.8)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        if style == .Default {
            title = highlight ? "Release To Pin" : "Drag Here To Pin"
        } else {
            title = highlight ? "Release To Unpin" : "Drag Here To Unpin"
        }
        radius_0 = highlight ? 22 : 20
        radius_1 = highlight ? 14 : 12
        kCoef = highlight ? 1 : 0.95

        let maskPath = UIBezierPath(arcCenter: CGPoint(x: bounds.width, y: bounds.width),
                                    radius: bounds.width * kCoef,
                                    startAngle: CGFloat(Double.pi),
                                    endAngle: CGFloat(Double.pi * 1.5),
                                    clockwise: true)
        maskPath.addLine(to: CGPoint(x: bounds.width, y: bounds.width))

        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath

        layer.mask = maskLayer

        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = NSTextAlignment.center

        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                          NSAttributedString.Key.foregroundColor: UIColor.white,
                          NSAttributedString.Key.paragraphStyle: textStyle]

        title.draw(in: CGRect(x: 0, y: bounds.height * 3.0 / 4, width: bounds.width, height: 20), withAttributes: attributes)

        let ring0 = UIBezierPath(arcCenter: CGPoint(x: bounds.width / 2, y: bounds.width / 2),
                                 radius: radius_0,
                                 startAngle: 0,
                                 endAngle: CGFloat(2 * Double.pi),
                                 clockwise: true)
        ring0.lineWidth = 3
        ring0.stroke()

        let ring1 = UIBezierPath(arcCenter: CGPoint(x: bounds.width / 2, y: bounds.width / 2),
                                 radius: radius_1, startAngle: 0,
                                 endAngle: CGFloat(2 * Double.pi),
                                 clockwise: true)
        ring1.lineWidth = 3
        ring1.stroke()
    }

//    func setHighlight(highlight: Bool) {
//        self.highlight = highlight
//        setNeedsDisplay()
//        if highlight {
//            let impactLight = UIImpactFeedbackGenerator(style: .medium)
//            impactLight.impactOccurred()
//        }
//    }

    func setStyle(style: FloatPinViewStyle) {
        self.style = style
        switch style {
        case .Default:
            backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.8)
            title = highlight ? "Release To Pin" : "Drag Here To Pin"
        case .Cancel:
            backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.8)
            title = highlight ? "Release To Unpin" : "Drag Here To Unpin"
        }
    }
}
