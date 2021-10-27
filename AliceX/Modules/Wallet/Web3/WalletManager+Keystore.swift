//
//  WalletManager+Keystore.swift
//  AliceX
//
//  Created by lmcmz on 10/6/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import web3swift

extension WalletManager {
    func saveKeystore(_ keystore: BIP32Keystore) throws {
        guard let userDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            throw WalletError.invalidPath
        }

        guard let keystoreParams = keystore.keystoreParams else {
            throw WalletError.malformedKeystore
        }

        guard let keystoreData = try? JSONEncoder().encode(keystoreParams) else {
            throw WalletError.malformedKeystore
        }

        guard let encryp = try? CryptTools.endcodeAESECB(dataToEncode: keystoreData, key: Setting.password) else {
            throw WalletError.encryptFailure
        }

        if !FileManager.default.fileExists(atPath: userDir + Setting.KeystoreDirectoryName) {
            do {
                try FileManager.default.createDirectory(atPath: userDir +
                                                            Setting.KeystoreDirectoryName, withIntermediateDirectories: true, attributes: nil)
            } catch {
                throw WalletError.invalidPath
            }
        }

        FileManager.default.createFile(atPath: userDir + Setting.KeystoreDirectoryName +
                                        Setting.KeystoreFileName, contents: encryp, attributes: [.protectionKey: FileProtectionType.complete])
    }

    func loadKeystore() throws -> BIP32Keystore {
        if let keystore = keystore {
            return keystore
        }

        guard let userDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask,
                                                                true).first else {
            throw WalletError.invalidPath
        }

        //        guard let keystoreManager = KeystoreManager.managerForPath(userDir + Setting.KeystoreDirectoryName,
        //                                                                   scanForHDwallets: true) else {
        //            throw WalletError.malformedKeystore
        //        }

        guard let keystoreManager = try? loadFile(path: userDir + Setting.KeystoreDirectoryName, scanForHDwallets: true, suffix: nil) else {
            throw WalletError.malformedKeystore
        }

        guard let address = keystoreManager.addresses?.first else {
            throw WalletError.malformedKeystore
        }
        guard let keystore = keystoreManager.walletForAddress(address) as? BIP32Keystore else {
            throw WalletError.malformedKeystore
        }

        return keystore
    }

    public func killKeystore() throws {
        guard let userDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            throw WalletError.invalidPath
        }

        if keystore != nil {
            if FileManager.default.fileExists(atPath: userDir + Setting.KeystoreDirectoryName) {
                do {
                    try FileManager.default.removeItem(atPath: userDir +
                                                        Setting.KeystoreDirectoryName + Setting.KeystoreFileName)
                    keystore = nil
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }

    func loadFile(path: String, scanForHDwallets: Bool = false, suffix: String? = nil) throws -> KeystoreManager? {
        let fileManager = FileManager.default
        var bip32keystores: [BIP32Keystore] = [BIP32Keystore]()
        var isDir: ObjCBool = false
        var exists = fileManager.fileExists(atPath: path, isDirectory: &isDir)
        if !exists, !isDir.boolValue {
            try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            exists = fileManager.fileExists(atPath: path, isDirectory: &isDir)
        }

        if !isDir.boolValue {
            return nil
        }

        let allFiles = try fileManager.contentsOfDirectory(atPath: path)
        if suffix != nil {
            for file in allFiles where file.hasSuffix(suffix!) {
                var filePath = path
                if !path.hasSuffix("/") {
                    filePath = path + "/"
                }
                filePath += file
                guard let content = fileManager.contents(atPath: filePath) else { continue }
                guard let decode = try? CryptTools.decodeAESECB(dataToDecode: content, key: "web3swift") else {
                    continue
                }

                if scanForHDwallets {
                    guard let bipkeystore = BIP32Keystore(decode) else { continue }
                    bip32keystores.append(bipkeystore)
                }
            }
        } else {
            for file in allFiles {
                var filePath = path
                if !path.hasSuffix("/") {
                    filePath = path + "/"
                }
                filePath += file
                guard let content = fileManager.contents(atPath: filePath) else { continue }
                guard let decode = try? CryptTools.decodeAESECB(dataToDecode: content, key: Setting.password) else {
                    continue
                }
                if scanForHDwallets {
                    guard let bipkeystore = BIP32Keystore(decode) else { continue }
                    bip32keystores.append(bipkeystore)
                }
            }
        }

        if bip32keystores.count == 0 {
            return nil
        }

        return KeystoreManager(bip32keystores)
    }
}
