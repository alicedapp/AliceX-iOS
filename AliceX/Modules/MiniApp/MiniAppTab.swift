//
//  AppTab.swift
//  AliceX
//
//  Created by lmcmz on 21/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation

enum MiniAppTab: Int, CaseIterable {
    case homeItem = 0
    case add
}

extension MiniAppTab {
    var name: String {
        switch self {
        case .homeItem:
            return MiniAppCollectionViewCell.nameOfClass
        case .add:
            return MiniAppAddCell.nameOfClass
        }
    }

    var size: CGSize {
        switch self {
        case .homeItem:
            let width = (Constant.SCREEN_WIDTH - 20 * 2 - 3 * 5) / 4
            return CGSize(width: width, height: width + 10)
        case .add:
            let width = Constant.SCREEN_WIDTH - 20 * 2
            return CGSize(width: width, height: 120)
        }
    }
}
