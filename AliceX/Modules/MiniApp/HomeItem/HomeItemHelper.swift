//
//  HomeItemHelper.swift
//  AliceX
//
//  Created by lmcmz on 22/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import Haneke
import PromiseKit

class HomeItemHelper {
    static let shared = HomeItemHelper()

    var list: [HomeItem] = []

    func add(item: HomeItem) {
        if list.contains(item) {
            return
        }
        list.append(item)
        storeInCache()
        postNotification()

        if !item.isApp {
            FaviconHelper.prefetchFavicon(urls: [item.url!])
        }
    }

    func remove(item: HomeItem) {
        if !list.contains(item) {
            return
        }

        guard let index = list.firstIndex(of: item) else {
            return
        }
        list.remove(at: index)
        storeInCache()
        postNotification()
    }

    func updatList(list: [HomeItem]) {
        self.list = list
        storeInCache()
    }

    func contain(item: HomeItem) -> Bool {
        return list.contains(item)
    }
}

extension HomeItemHelper {
    func loadFromCache() -> Promise<[HomeItem]> {
        return Promise<[HomeItem]> { seal in
            let cacheKey = CacheKey.homeItemList
            Shared.stringCache.fetch(key: cacheKey).onSuccess { result in
                var itemList: [HomeItem] = []
                let idList = result.split(separator: ",")
                for id in idList {
                    if id.hasPrefix("http"), let url = URL(string: String(id)) {
                        let web = HomeItem.web(url: url)
                        itemList.append(web)
                    } else {
                        let app = HomeItem.app(name: String(id))
                        itemList.append(app)
                    }
                }
                self.list = itemList
                seal.fulfill(itemList)
            }.onFailure { error in
                if let err = error, err._code == -100 { // No Key
                    self.list = [.app(name: "DAOstack"),
                                 //                                 .app(name: "Test"),
//                                 .app(name: "CryptoKitties"),
                                 //                                 .app(name: "Foam"),
                                 .web(url: URL(string: "https://uniswap.exchange")!),
                                 .web(url: URL(string: "https://opensea.io/assets")!),
                                 .web(url: URL(string: "https://www.mycryptoheroes.net")!),
                                 .web(url: URL(string: "https://peepeth.com/a/login")!),
                                 .web(url: URL(string: "https://app.compound.finance")!)]
                    self.storeInCache()
                    seal.fulfill(self.list)
                    return
                }
                HUDManager.shared.showError(text: "Failed to fetch home list")
            }
        }
    }

    func storeInCache() {
        let cacheKey = CacheKey.homeItemList
        let idList = list.compactMap { $0.id }.joined(separator: ",")
        Shared.stringCache.set(value: idList, key: cacheKey)
    }

    func postNotification() {
        NotificationCenter.default.post(name: .homeItemListChange, object: nil)
    }
}
