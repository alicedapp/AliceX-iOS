//
//  PinItem.swift
//  AliceX
//
//  Created by lmcmz on 2/9/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation

enum PinItem {
    case website(image: UIImage, url: URL, title: String)
    case dapplet(image: UIImage, url: URL, title: String)
    case transaction(image: UIImage, url: URL, title: String)
}

extension PinItem: Hashable {}
