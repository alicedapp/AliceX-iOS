//
//  BrowserSetting.swift
//  AliceX
//
//  Created by lmcmz on 22/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation

enum SearchEngine: Int {
    case DuckDuckGo = 0
    case Google

    var baseURL: URL {
        switch self {
        case .DuckDuckGo:
            return URL(string: "https://duckduckgo.com")!
        case .Google:
            return URL(string: "https://google.com")!
        }
    }

    var queryString: String {
        switch self {
        case .DuckDuckGo:
            return "https://duckduckgo.com/?q="
        case .Google:
            return "https://www.google.com/search?q="
        }
    }
}
