//
//  Constant.swift
//  AliceX
//
//  Created by lmcmz on 10/6/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation

typealias VoidBlock = (() -> Void)?
typealias StringBlock = ((String) -> Void)

class Setting {
    static let AliceKeychainPrefix = "AliceKeychain"
    static let MnemonicsKey = "AliceMnemonics"
    static let WalletName = "AliceWallet"
    static let KeystoreDirectoryName = "/keystore"
    static let KeystoreFileName = "/key.json"
    static let password = "web3swift"
}

typealias MainFont = Font.HelveticaNeue
enum Font {
    enum HelveticaNeue: String {
        case ultraLightItalic = "UltraLightItalic"
        case medium = "Medium"
        case mediumItalic = "MediumItalic"
        case ultraLight = "UltraLight"
        case italic = "Italic"
        case light = "Light"
        case thinItalic = "ThinItalic"
        case lightItalic = "LightItalic"
        case bold = "Bold"
        case thin = "Thin"
        case condensedBlack = "CondensedBlack"
        case condensedBold = "CondensedBold"
        case boldItalic = "BoldItalic"

        func with(size: CGFloat) -> UIFont {
            return UIFont(name: "HelveticaNeue-\(rawValue)", size: size)!
        }
    }
}

extension Notification.Name {
    static let networkChange = Notification.Name("networkChange")
    static let currencyChange = Notification.Name("currencyChange")
    static let gasSelectionCahnge = Notification.Name("gasSelectionCahnge")
}

class Constant {
    static var SAFE_TOP: CGFloat {
        if #available(iOS 11, *) {
            return UIApplication.shared.keyWindow!.safeAreaInsets.top
        }
        return 0
    }

    static var SAFE_BTTOM: CGFloat {
        if #available(iOS 11, *) {
            return UIApplication.shared.keyWindow!.safeAreaInsets.bottom
        }
        return 0
    }

    static let SCREEN_WIDTH: CGFloat = UIScreen.main.bounds.width
    static let SCREEN_HEIGHT: CGFloat = UIScreen.main.bounds.height
}
