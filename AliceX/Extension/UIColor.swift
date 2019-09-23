//
//  UIColor.swift
//  AliceX
//
//  Created by lmcmz on 10/6/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let hexString: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x0000_00FF
        let redInt = Int(color >> 16) & mask
        let greenInt = Int(color >> 8) & mask
        let blueInt = Int(color) & mask
        let red = CGFloat(redInt) / 255.0
        let green = CGFloat(greenInt) / 255.0
        let blue = CGFloat(blueInt) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    func toHexString() -> String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let rgb: Int = (Int)(red * 255) << 16 | (Int)(green * 255) << 8 | (Int)(blue * 255) << 0
        return String(format: "#%06x", rgb)
    }

    func toColor(_ color: UIColor, percentage: CGFloat) -> UIColor {
        let percentage = max(min(percentage, 100), 0) / 100
        switch percentage {
        case 0: return self
        case 1: return color
        default:
            var (red1, green1, blue1, alpha1): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
            var (red2, green2, blue2, alpha2): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
            guard getRed(&red1, green: &green1, blue: &blue1, alpha: &alpha1) else { return self }
            guard color.getRed(&red2, green: &green2, blue: &blue2, alpha: &alpha2) else { return self }

            return UIColor(red: CGFloat(red1 + (red2 - red1) * percentage),
                           green: CGFloat(green1 + (green2 - green1) * percentage),
                           blue: CGFloat(blue1 + (blue2 - blue1) * percentage),
                           alpha: CGFloat(alpha1 + (alpha2 - alpha1) * percentage))
        }
    }

    class var random: UIColor {
        return UIColor(red: .random(in: 0 ... 1), green: .random(in: 0 ... 1), blue: .random(in: 0 ... 1), alpha: 1.0)
    }
    
    func interpolate(between other: UIColor, percent: CGFloat) -> UIColor? {
        return UIColor.interpolate(between: self, and: other, percent: percent)
    }
    
    static func interpolate(between color: UIColor,
                            and other: UIColor,
                            percent: CGFloat) -> UIColor? {
        var redA: CGFloat = 0.0
        var greenA: CGFloat = 0.0
        var blueA: CGFloat = 0.0
        var alphaA: CGFloat = 0.0
        guard color.getRed(&redA, green: &greenA, blue: &blueA, alpha: &alphaA) else {
            return nil
        }
        
        var redB: CGFloat = 0.0
        var greenB: CGFloat = 0.0
        var blueB: CGFloat = 0.0
        var alphaB: CGFloat = 0.0
        guard other.getRed(&redB, green: &greenB, blue: &blueB, alpha: &alphaB) else {
            return nil
        }
        
        let iRed = CGFloat(redA + percent * (redB - redA))
        let iBlue = CGFloat(blueA + percent * (blueB - blueA))
        let iGreen = CGFloat(greenA + percent * (greenB - greenA))
        let iAlpha = CGFloat(alphaA + percent * (alphaB - alphaA))
        
        return UIColor(red: iRed, green: iGreen, blue: iBlue, alpha: iAlpha)
    }
}
