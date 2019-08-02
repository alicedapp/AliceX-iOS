//
//  CGRect.swift
//  AliceX
//
//  Created by lmcmz on 3/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation

extension CGRect {
    var minEdge: CGFloat {
        return min(width, height)
    }

    var maxEdge: CGFloat {
        return max(width, height)
    }
}
