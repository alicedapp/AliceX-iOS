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
    static let WalletName = "Alice X"
    static let KeystoreDirectoryName = "/keystore"
    static let KeystoreFileName = "/key.json"
    static let password = "web3swift"

    static let termURL = URL(string: "https://www.alicedapp.com/terms-of-service")!
    static let privacyURL = URL(string: "https://www.alicedapp.com/privacy-policy")!
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
    static let walletChange = Notification.Name("walletChange")
    static let accountChange = Notification.Name("accountChange")

//    static let accountChange = Notification.Name("accountCreate")

    static let networkChange = Notification.Name("networkChange")
    static let currencyChange = Notification.Name("currencyChange")
    static let gasSelectionCahnge = Notification.Name("gasSelectionCahnge")
//    static let addCustomRPC = Notification.Name("addCustomRPC")
//    static let updateCustomRPC = Notification.Name("updateRPC")
    static let customRPCChange = Notification.Name("customRPCChange")
    static let newPendingTransaction = Notification.Name("newPendingTransaction")
    static let removePendingTransaction = Notification.Name("removePendingTransaction")

    static let wallectConnectServerConnect = Notification.Name("wallectConnectServerConnect")
    static let wallectConnectServerDisconnect = Notification.Name("wallectConnectServerDisconnect")

    static let wallectConnectClientConnect = Notification.Name("wallectConnectClientConnect")
    static let wallectConnectClientDisconnect = Notification.Name("wallectConnectClientDisconnect")

    static let priceUpdate = Notification.Name("priceUpdate")
    static let watchingCoinListChange = Notification.Name("watchingCoinListChange")

    static let homeItemListChange = Notification.Name("homeItemListChange")

    static let faviconDownload = Notification.Name("faviconDownload")

    static let mnemonicBackuped = Notification.Name("mnemonicBackuped")
    
    
    // Chat
    
    static let chatLoginSuccess = Notification.Name("chatLoginSuccess")
}

class CacheKey {
    static let web3NetStoreKey = "alice.web3.net.v1"
    static let web3CustomRPCKey = "alice.web3.custom.rpc"

    static let assetNFTKey = "alice.asset.NFT"
//    static let assetERC20Key = "alice.asset.erc20"

    static let homeItemList = "alice.miniApp.list"
    static let browserDappList = "alice.browser.dapp.list"

    static let watchingList = "alice.asset.watchingList"
    static let unWatchingList = "alice.asset.un.watchingList"

    static let blockchainKey = "alice.asset.watchingList"

    static let coinInfoList = "alice.asset.coinInfoList"
    
    static let txHistory = "alice.tx.history"
}

class IMPCacheKey {
    static let accountCacheKey = "alice.wallet.accounts"
}

class Constant {
    static let placeholder = UIImage.imageWithColor(color: UIColor(hex: "F1F5F8"))

    static let AliceCommunityTelegram = URL(string: "https://t.me/alicecommunity")!
    static let AliceCommunityTelegramScheme = URL(string: "tg://resolve?domain=alicecommunity")!

    static let AliceTwitterScheme = URL(string: "twitter://user?screen_name=heyaliceapp")!
    static let AliceTwitter = URL(string: "https://twitter.com/heyaliceapp")!

    static var SAFE_TOP: CGFloat {
        if #available(iOS 11, *) {
            return UIApplication.shared.keyWindow!.safeAreaInsets.top
        }
        return 0
    }

    static var SAFE_BOTTOM: CGFloat {
        if #available(iOS 11, *) {
            return UIApplication.shared.keyWindow!.safeAreaInsets.bottom
        }
        return 0
    }

    static let SCREEN_WIDTH: CGFloat = UIScreen.main.bounds.width
    static let SCREEN_HEIGHT: CGFloat = UIScreen.main.bounds.height

    static let SCREEN_HEIGHT_NO_SAFE: CGFloat = UIScreen.main.bounds.height - SAFE_TOP - SAFE_BOTTOM

    class func randomEmoji() -> String {
        let emoji = ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🦝", "🐻", "🐼", "🦘", "🦡", "🐨", "🐯", "🦁", "🐮", "🐷", "🐽", "🐸", "🐵", "🙈", "🙉", "🙊", "🐒", "🐔", "🐧", "🐦", "🐤", "🐣", "🐥", "🦆", "🦢", "🦅", "🦉", "🦚", "🦜", "🦇", "🐺", "🐗", "🐴", "🦄", "🐝", "🐛", "🦋", "🐌", "🐚", "🐞", "🐜", "🦗", "🕷", "🕸", "🦂", "🦟", "🦠", "🐢", "🐍", "🦎", "🦖", "🦕", "🐙", "🦑", "🦐", "🦀", "🐡", "🐠", "🐟", "🐬", "🐳", "🐋", "🦈", "🐊", "🐅", "🐆", "🦓", "🦍", "🐘", "🦏", "🦛", "🐪", "🐫", "🦙", "🦒", "🐃", "🐂", "🐄", "🐎", "🐖", "🐏", "🐑", "🐐", "🦌", "🐕", "🐩", "🐈", "🐓", "🦃", "🕊", "🐇", "🐁", "🐀", "🐿", "🦔", "🐾", "🐉", "🐲"]

        return emoji.randomElement()!
    }

    static let animals: [String] = ["baboon", "cow", "frog", "llama", "sheep", "bear", "crab", "giraffe", "crocodile", "globefish", "moose", "sloth", "deadlock", "goat", "mouse", "snake", "deer", "goldfish", "owl", "bulldog", "dog", "guinea", "panda", "kangaroo", "squirrel", "butterfly", "dolphin", "hedgehog", "pig", "starfish", "duck", "swan", "cat", "eagle", "horse", "rabbit", "tiger", "chameleon", "elephant", "koala", "raccoon", "wolf", "chimpanzee", "fennec", "lemur", "seal", "colibri", "fox", "lion", "shark"]

    class func randomAnimal() -> String {
        return Constant.animals.randomElement()!
    }
}

class APIKey {
    static let infuraKey = "da3717f25f824cc1baa32d812386d93f"
    static let etherscanKey = "HKFT391NVPRQTI4348DRSCWZPMA4JJPR9R"
}
