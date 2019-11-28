//
//  CryptTools.swift
//  AliceX
//
//  Created by lmcmz on 29/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import CryptoSwift
import UIKit

class CryptTools: NSObject {
    // encode
    public static func endcodeAESECB(dataToEncode: Data, key: String) throws -> Data {
        do {
            let aes = try AES(key: Padding.zeroPadding.add(to: key.bytes, blockSize: AES.blockSize), blockMode: ECB())
            let encoded = try aes.encrypt(dataToEncode.bytes)
            return Data(fromArray: encoded)
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }

    // decode
    public static func decodeAESECB(dataToDecode: Data, key: String) throws -> Data {
        let encrypted: [UInt8] = dataToDecode.bytes
        do {
            let aes = try AES(key: Padding.zeroPadding.add(to: key.bytes, blockSize: AES.blockSize), blockMode: ECB())
            let decode = try aes.decrypt(encrypted)
            let encoded = Data(decode)
            return encoded
        } catch {
            throw error
        }
    }
}
