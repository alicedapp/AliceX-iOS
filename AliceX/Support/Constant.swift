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
//    static let addCustomRPC = Notification.Name("addCustomRPC")
//    static let updateCustomRPC = Notification.Name("updateRPC")
    static let customRPCChange = Notification.Name("customRPCChange")
}


class CacheKey {
    static let web3NetStoreKey = "alice.web3.net"
    static let web3CustomRPCKey = "alice.web3.custom.rpc"
}

class Constant {
    
    static let AliceCommunityTelegram = URL(string: "https://t.me/alicecommunity")!
    static let AliceCommunityTelegramScheme = URL(string: "tg://domain=alicecommunity")!
    
    static let AliceTwitterScheme = URL(string: "twitter://user?screen_name=heyaliceapp")!
    static let AliceTwitter = URL(string: "https://twitter.com/heyaliceapp")!
    
    
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

extension Constant {
    static let infuraKey = "da3717f25f824cc1baa32d812386d93f"
}
