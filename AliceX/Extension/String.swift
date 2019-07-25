//
//  String.swift
//  AliceX
//
//  Created by lmcmz on 4/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import web3swift

extension String {
    
    func index(from: Int) -> Index {
        return index(startIndex, offsetBy: from)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
    
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
    
//    func validateUrl () -> Bool {
//        let urlRegEx = "^(?:http(s)?:\\/\\/)?[\\w.-]+(?:\\.[\\w\\.-]+)+[\\w\\-\\._~:/?#[\\]@!\\$&'\\(\\)\\*\\+,;=.]+$"
//        return NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluate(with: self)
//    }
    
    func validateUrl() -> Bool {
        guard let url = URL(string: self) else {
                return false
        }
        
        return UIApplication.shared.canOpenURL(url)
    }

    var drop0x: String {
        if count > 2 && substring(with: 0..<2) == "0x" {
            return String(dropFirst(2))
        }
        return self
    }
    
    func addHttpsPrefix() -> String {
        if !self.hasPrefix("https://") {
            return "https://" + self
        }
        return self
    }
    
    func addHttpPrefix() -> String {
        if !self.hasPrefix("http://") {
            return "http://" + self
        }
        return self
    }
    
    func addHexPrefix() -> String {
        if !self.hasPrefix("0x") {
            return "0x" + self
        }
        return self
    }
    
    var firstUppercased: String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    var firstCapitalized: String {
        return prefix(1).capitalized + dropFirst()
    }
    
    var hexDecodeUTF8: String? {
        guard let data = Data.fromHex(self) else {
            return nil
        }
        guard let decode = String(data: data, encoding: .utf8) else {
            return nil
        }
        return decode
    }
    
    var ethAddress: EthereumAddress? {
        guard let address = EthereumAddress(self) else {
            return nil
        }
        return address
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
    
    func round( decimal: Int) -> String {
        return String(Float(self)!.rounded(toPlaces: decimal))
    }
    
    func stripHexPrefix() -> String {
        if self.hasPrefix("0x") {
            let indexStart = self.index(self.startIndex, offsetBy: 2)
            return String(self[indexStart...])
        }
        return self
    }
    
}
