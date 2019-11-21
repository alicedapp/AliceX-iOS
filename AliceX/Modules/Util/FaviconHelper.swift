//
//  FaviconHelper.swift
//  AliceX
//
//  Created by lmcmz on 20/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import Kingfisher
import PromiseKit

class FaviconHelper {
    
    class func getBestFavicon(domain: String) -> Promise<URL> {
        return Promise<URL> { seal in
//           guard let domain = url.host else {
//            throw MyError.FoundNil("Can't find domain")
//           }
            FaviconGrabberAPI.request(.favicon(domain: domain)) { result in
                switch result {
                case let .success(response):
                    guard let modelArray = response.mapArray(FaviconGrabberModel.self, designatedPath: "icons") else {
                        seal.reject(MyError.DecodeFailed)
                        return
                    }

                    let hasSize = modelArray.filter { $0!.sizes != nil && $0!.sizes != "any"}

                    if hasSize.count > 0 {
                        let first = hasSize.sorted { (model1, model2) -> Bool in
                            let size1 = Int(String((model1?.sizes!.split(separator: "x").first)!))!
                            let size2 = Int(String((model2?.sizes!.split(separator: "x").first)!))!
                            return size1 > size2
                        }.first!

                        guard let firstURL = first, let imageURL = URL(string: firstURL.src) else {
                            seal.reject(MyError.FoundNil("Image URL convert failed"))
                            return
                        }

                        seal.fulfill(imageURL)
                    } else {
                        guard let firstModel = modelArray.first else {
                            seal.reject(MyError.FoundNil("\(domain) Not favicon found"))
                            return
                        }

                        guard let firstURL = firstModel, let imageURL = URL(string: firstURL.src) else {
                            seal.reject(MyError.FoundNil("Image URL convert failed"))
                            return
                        }

                        seal.fulfill(imageURL)
                    }

                case let .failure(error):
                    seal.reject(error)
                }
            }
        }
    }

    class func prefetchFavicon(urls: [URL]) {
        for url in urls {
            guard let domain = url.host else {
                continue
            }

            if ImageCache.default.isCached(forKey: domain) {
                continue
            }

            firstly {
                FaviconHelper.getBestFavicon(domain: domain)
            }.done { imageURL in
                KingfisherManager.shared.retrieveImage(with: imageURL) { result in
                    switch result {
                    case let .success(response):
                        ImageCache.default.store(response.image, forKey: domain)
                        let userInfo = ["domain": domain]
                        NotificationCenter.default.post(name: .faviconDownload, object: nil, userInfo: userInfo)
                    case let .failure(error):
                        break
                    }
                }
            }.catch { error in
                print(error)
            }
        }
    }
}
