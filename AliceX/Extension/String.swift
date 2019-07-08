//
//  String.swift
//  AliceX
//
//  Created by lmcmz on 4/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation

extension String {
    var firstUppercased: String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    var firstCapitalized: String {
        return prefix(1).capitalized + dropFirst()
    }
    
    func split(by length: Int) -> [String] {
        var startIndex = self.startIndex
        var results = [Substring]()
        
        while startIndex < self.endIndex {
            let endIndex = self.index(startIndex, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            results.append(self[startIndex..<endIndex])
            startIndex = endIndex
        }
        
        return results.map { String($0) }
    }
}
