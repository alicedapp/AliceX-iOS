//
//  HomeItem.swift
//  AliceX
//
//  Created by lmcmz on 20/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import Kingfisher

enum HomeItem {
    case web(url: URL)
    case app(name: String)

    var id: String {
        switch self {
        case let .app(name):
            return name
        case let .web(url):
            return url.absoluteString
        }
    }

    var name: String {
        switch self {
        case let .app(name):
            return name
        case let .web(url):
            guard let domain = url.host else {
                return url.absoluteString
            }
//            guard let first = domain.split(separator: ".").first else {
//                return url.absoluteString
//            }

            var urls = domain.split(separator: ".").dropLast(1)

            if urls.count == 2 {
                urls = urls.dropFirst()
            }
            return urls.joined().firstCapitalized
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
            return HomeWebBrowserWrapper.make(urlString: url.absoluteString)
        case let .app(name):
            return RNModule.makeVCwithApp(item: HomeItem.app(name: name))
        }
    }

    var url: URL? {
        switch self {
        case .app:
            return nil
        case let .web(url):
            return url
        }
    }

    var appImage: URL? {
        switch self {
        case let .app(name):
            return URL(string: "https://github.com/alicedapp/AliceX/blob/master/src/Apps/\(name)/Assets/logo.png?raw=true")!
        case .web:
            // fetch from FaviconHelper
            return nil
        }
    }
}

extension HomeItem: Hashable, Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }

    var hashValue: Int {
        return id.hashValue
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
