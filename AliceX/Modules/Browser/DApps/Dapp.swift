//
//  Dapp.swift
//  AliceX
//
//  Created by lmcmz on 12/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation

enum Method: String, Decodable {
    // case getAccounts
    case sendTransaction
    case signTransaction
    case signPersonalMessage
    case signMessage
    case signTypedMessage
    case unknown

    init(string: String) {
        self = Method(rawValue: string) ?? .unknown
    }
}

// struct DappCommand: Decodable {
//    let name: Method
//    let id: Int
//    let object: [String: DappCommandObjectValue]
// }
//
// struct DappCallback {
//    let id: Int
//    let value: DappCallbackValue
// }
//
// enum DappCallbackValue {
//    case signTransaction(Data)
//    case sentTransaction(Data)
//    case signMessage(Data)
//    case signPersonalMessage(Data)
//    case signTypedMessage(Data)
//
//    var object: String {
//        switch self {
//        case .signTransaction(let data):
//            return data.hexEncoded
//        case .sentTransaction(let data):
//            return data.hexEncoded
//        case .signMessage(let data):
//            return data.hexEncoded
//        case .signPersonalMessage(let data):
//            return data.hexEncoded
//        case .signTypedMessage(let data):
//            return data.hexEncoded
//        }
//    }
// }
//
// struct DappCommandObjectValue: Decodable {
//    public var value: String = ""
//    public var array: [EthTypedData] = []
//    public init(from coder: Decoder) throws {
//        let container = try coder.singleValueContainer()
//        if let intValue = try? container.decode(Int.self) {
//            self.value = String(intValue)
//        } else if let stringValue = try? container.decode(String.self) {
//            self.value = stringValue
//        } else {
//            var arrayContainer = try coder.unkeyedContainer()
//            while !arrayContainer.isAtEnd {
//                self.array.append(try arrayContainer.decode(EthTypedData.self))
//            }
//        }
//    }
// }

//
// enum SolidityJSONValue: Decodable {
//    case none
//    case bool(value: Bool)
//    case string(value: String)
//    case address(value: String)
//
//    // we store number in 64 bit integers
//    case int(value: Int64)
//    case uint(value: UInt64)
//
//    var string: String {
//        switch self {
//        case .none:
//            return ""
//        case .bool(let bool):
//            return bool ? "true" : "false"
//        case .string(let string):
//            return string
//        case .address(let address):
//            return address
//        case .uint(let uint):
//            return String(uint)
//        case .int(let int):
//            return String(int)
//        }
//    }
//
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        if let boolValue = try? container.decode(Bool.self) {
//            self = .bool(value: boolValue)
//        } else if let uint = try? container.decode(UInt64.self) {
//            self = .uint(value: uint)
//        } else if let int = try? container.decode(Int64.self) {
//            self = .int(value: int)
//        } else if let string = try? container.decode(String.self) {
//            if CryptoAddressValidator.isValidAddress(string) {
//                self = .address(value: string)
//            } else {
//                self = .string(value: string)
//            }
//        } else {
//            self = .none
//        }
//    }
// }
//
// enum AddressValidatorType {
//    case ethereum
//
//    var addressLength: Int {
//        switch self {
//        case .ethereum: return 42
//        }
//    }
// }
//
// struct CryptoAddressValidator {
//    static func isValidAddress(_ value: String?, type: AddressValidatorType = .ethereum) -> Bool {
//        guard value?.count == type.addressLength else {
//            return false
//        }
//        return true
//    }
// }
//
// extension FixedWidthInteger {
//    func getHexData() -> Data {
//        var string = String(self, radix: 16)
//        if string.count % 2 != 0 {
//            //pad to even
//            string = "0" + string
//        }
//        let data = Data(hex: string)
//        return data
//    }
//
//    func getTypedData(size: Int) -> Data {
//        var intValue = bigEndian
//        var data = Data(buffer: UnsafeBufferPointer(start: &intValue, count: 1))
//        let num = size / 8 - 8
//        if num > 0 {
//            data.insert(contentsOf: [UInt8].init(repeating: 0, count: num), at: 0)
//        } else if num < 0 {
//            data = data.advanced(by: abs(num))
//        }
//        return data
//    }
// }
//
// private func parseIntSize(type: String, prefix: String) -> Int {
//    guard type.starts(with: prefix) else {
//        return -1
//    }
//    guard let size = Int(type.dropFirst(prefix.count)) else {
//        if type == prefix {
//            return 256
//        }
//        return -1
//    }
//
//    if size < 8 || size > 256 || size % 8 != 0 {
//        return -1
//    }
//    return size
// }
