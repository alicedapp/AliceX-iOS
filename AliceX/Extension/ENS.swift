//
//  ENS.swift
//  AliceX
//
//  Created by lmcmz on 17/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import PromiseKit
import web3swift

extension ENS {
    func getAddressWithPromise(forNode node: String) throws -> Promise<EthereumAddress> {
        return Promise<EthereumAddress> { seal in
            guard let resolver = try? self.registry.getResolver(forDomain: node) else {
                throw Web3Error.processingError(desc: "Failed to get resolver for domain")
            }
            guard let isAddrSupports = try? resolver.supportsInterface(interfaceID: "0x3b3b57de") else {
                throw Web3Error.processingError(desc: "Resolver don't support interface with this ID")
            }
            guard isAddrSupports else {
                throw Web3Error.processingError(desc: "Address isn't supported")
            }
            resolver.getAddressWithPromise(forNode: node).done { address in
                seal.fulfill(address)
            }.catch { _ in
                seal.reject(Web3Error.processingError(desc: "Can't get address"))
            }
        }
    }
}

extension ENS.Resolver {
    func getAddressWithPromise(forNode node: String) -> Promise<EthereumAddress> {
        return Promise<EthereumAddress> { seal in

            let defaultOptions = TransactionOptions.defaultOptions
            guard let contract = self.web3.contract(Web3.Utils.resolverABI,
                                                    at: self.resolverContractAddress, abiVersion: 2) else {
                throw Web3Error.processingError(desc: "Contact fetch failed")
            }

            guard let nameHash = NameHash.nameHash(node) else { throw Web3Error.processingError(desc: "Failed to get name hash") }
            guard let transaction = contract.read("addr", parameters: [nameHash as AnyObject], extraData: Data(), transactionOptions: defaultOptions) else { throw Web3Error.transactionSerializationError }

            transaction.callPromise(transactionOptions: defaultOptions).done { result in
                guard let address = result["0"] as? EthereumAddress else { throw Web3Error.processingError(desc: "Can't get address") }
                seal.fulfill(address)
            }.catch { _ in
                seal.reject(Web3Error.processingError(desc: "Can't call transaction"))
            }
        }
    }

    //    public func getAddress(forNode node: String) throws -> EthereumAddress {
}
