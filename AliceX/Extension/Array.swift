//
//  Array.swift
//  AliceX
//
//  Created by lmcmz on 4/3/20.
//  Copyright © 2020 lmcmz. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    public mutating func mergeElements<C: Collection>(newElements: C) where C.Iterator.Element == Element {
        let filteredList = newElements.filter { !self.contains($0) }
        append(contentsOf: filteredList)
    }
}
