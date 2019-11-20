//
//  HomeItem.swift
//  AliceX
//
//  Created by lmcmz on 20/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation

enum HomeItem {
    case web(url: URL)
    case app(name: String)

    var name: String {
        switch self {
        case let .app(name):
            return name
        case let .web(url):
            guard let domain = url.host else {
                return url.absoluteString
            }
            guard let fisrt = domain.split(separator: ".").first else {
                return url.absoluteString
            }
            return String(fisrt).firstCapitalized
        }
    }

    var isApp: Bool {
        switch self {
        case .app:
            return true
        default:
            return false
        }
    }

    var vc: UIViewController {
        switch self {
        case let .web(url):
            return BrowserWrapperViewController.make(urlString: url.absoluteString)
        case let .app(name):
            return RNModule.makeViewController(module: .app(name: name))
        }
    }
    
    var url: URL? {
        switch self {
        case .app:
            return nil
        case .web(let url):
            return url
        }
    }
}
