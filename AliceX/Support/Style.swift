//
//  Style.swift
//  AliceX
//
//  Created by lmcmz on 10/6/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit

class AliceColor {
    @available(iOS 12.0, *)
    static var themeMode: UIUserInterfaceStyle {
        guard let keyWindow = UIApplication.shared.keyWindow else {
            return UIUserInterfaceStyle.light
        }
        return keyWindow.traitCollection.userInterfaceStyle
    }

    @available(iOS 12.0, *)
    static var isDarkMode: Bool {
        return themeMode == .dark
    }

    class func lightBackground() -> UIColor {
        return AliceColor.color(light: UIColor(hex: "F1F4F5"),
                                dark: UIColor(hex: "212121"))
    }

    class func white() -> UIColor {
        return AliceColor.color(light: .white,
                                dark: .black)
    }

    class func whiteGrey() -> UIColor {
        return AliceColor.color(light: .white,
                                dark: UIColor(hex: "212121"))
    }

    class func greyNew() -> UIColor {
        return AliceColor.color(light: UIColor(hex: "C0C0C0"),
                                dark: UIColor(hex: "797979"))
    }

    class func darkGrey() -> UIColor {
        return AliceColor.color(light: UIColor(hex: "565656"),
                                dark: UIColor(hex: "D5D5D5"))
    }

    class func payButton() -> UIColor {
        return AliceColor.color(light: UIColor(hex: "333333"),
                                dark: UIColor(hex: "C0C0C0"))
    }

    static let dark = UIColor(hex: "444444", alpha: 0.8)

    static let lightDark = UIColor(hex: "9D9D9D", alpha: 0.8)

    static let grey = UIColor(hex: "EAEDEF", alpha: 1)
    static let lightGrey = UIColor(hex: "EEF1F2", alpha: 1)

    static let red = UIColor(hex: "FF6565", alpha: 1)
    static let blue = UIColor(hex: "1B92FF", alpha: 1)
    static let green = UIColor(hex: "ADF157", alpha: 1)

    class func color(light: UIColor, dark: UIColor) -> UIColor {
        if #available(iOS 12, *) {
            return AliceColor.isDarkMode ? dark : light
        }
        return light
    }
}
