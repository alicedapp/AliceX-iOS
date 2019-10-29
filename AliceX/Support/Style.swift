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
        return UIScreen.main.traitCollection.userInterfaceStyle
    }

    @available(iOS 12.0, *)
    static var isDarkMode: Bool {
        return themeMode == .dark
    }

    static let dark = UIColor(hex: "444444", alpha: 0.8)

    static let lightDark = UIColor(hex: "9D9D9D", alpha: 0.8)

    static let grey = UIColor(hex: "EAEDEF", alpha: 1)
    static let lightGrey = UIColor(hex: "EEF1F2", alpha: 1)

    static let red = UIColor(hex: "FF6565", alpha: 1)
    static let blue = UIColor(hex: "1B92FF", alpha: 1)
}
