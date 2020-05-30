//
//  TransactionManager.swift
//  AliceX
//
//  Created by lmcmz on 10/6/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import BigInt
import PromiseKit
import SPStorkController
import UIKit
import web3swift

// TODO: Change all function to Promise
class TransactionManager {
    static let shared = TransactionManager()

    // MARK: - Smart Contract Popup

//    class func showContractWriteView(contractAddress: String,
//                                     functionName: String,
//                                     abi: String,
//                                     parameters: [Any],
//                                     value: BigUInt,
//                                     extraData: Data,
//                                     success: @escaping StringBlock) {
//    }

    class func showContractWriteView(contractAddress: String,
                                     functionName: String,
                                     abi: String,
                                     parameters: [Any],
                                     value: BigUInt,
                                     gasLimit: BigUInt = BigUInt(0),
                                     extraData: Data,
                                     success: @escaping StringBlock) {
        let topVC = UIApplication.topViewController()
        let modal = ContractPopUp.make(contractAddress: contractAddress,
                                       functionName: functionName, parameters: parameters,
                                       extraData: extraData, value: value,
                                       abi: abi, gasLimit: gasLimit, success: success)
        let height = 525 - 34 + Constant.SAFE_BOTTOM
        topVC?.presentAsStork(modal, height: height)
    }

    class func getAddress() throws -> String {
        guard let address = WalletManager.currentAccount?.address else { throw WalletError.accountDoesNotExist }
        return address
    }

    // MARK: - Balance

    public func etherBalanceSync() throws -> String {
        guard let address = WalletManager.currentAccount?.address else { throw WalletError.accountDoesNotExist }
        guard let ethereumAddress = EthereumAddress(address) else { throw WalletError.invalidAddress }

        guard let balanceInWeiUnitResult = try? WalletManager.web3Net.eth.getBalance(address: ethereumAddress) else {
            throw WalletError.insufficientBalance
        }

        guard let balanceInEtherUnitStr = Web3.Utils.formatToEthereumUnits(balanceInWeiUnitResult,
                                                                           toUnits: .eth,
                                                                           decimals: 6, decimalSeparator: ".")
        else { throw WalletError.conversionFailure }

        return balanceInEtherUnitStr
    }

    public func etherBalance() -> Promise<String> {
        return Promise<String> { seal in
            guard let address = WalletManager.currentAccount?.address else {
                seal.reject(WalletError.accountDoesNotExist)
                return
            }
            guard let ethereumAddress = EthereumAddress(address) else {
                seal.reject(WalletError.invalidAddress)
                return
            }

            firstly {
                WalletManager.web3Net.eth.getBalancePromise(address: ethereumAddress)
            }.done { balanceInWeiUnitResult in
                guard let balanceInEtherUnitStr = Web3.Utils.formatToEthereumUnits(balanceInWeiUnitResult,
                                                                                   toUnits: .eth,
                                                                                   decimals: 6, decimalSeparator: ".")
                else {
                    seal.reject(WalletError.conversionFailure)
                    return
                }
                seal.fulfill(balanceInEtherUnitStr)
            }
        }
//        DispatchQueue.global().async {
//            let balance = try? self.etherBalanceSync()
//            DispatchQueue.main.async {
//                completion(balance)
//            }
//        }
    }

    // MARK: - Send Transaction

    class func showPaymentView(toAddress: String,
                               amount: BigUInt,
                               data: Data,
                               coin: Coin,
                               gasPrice: GasPrice = GasPrice.average,
                               gasLimit: BigUInt = BigUInt(0),
                               success: @escaping StringBlock) {
        let topVC = UIApplication.topViewController()
        let modal = PaymentPopUp.make(toAddress: toAddress,
                                      amount: amount,
                                      data: data,
                                      coin: coin,
                                      gasPrice: gasPrice,
                                      gasLimit: gasLimit,
                                      success: success)
        let height = 430 - 34 + Constant.SAFE_BOTTOM
        modal.modalPresentationStyle = .overCurrentContext
        topVC?.presentAsStork(modal, height: height)
    }

    public func sendEtherSync(to address: String,
                              amount: BigUInt,
                              data: Data,
                              password _: String = "web3swift",
                              gasPrice: GasPrice = GasPrice.average,
                              gasLimit: TransactionOptions.GasLimitPolicy = .automatic) -> Promise<String> {
        return TransactionManager.writeSmartContract(contractAddress: address,
                                                     functionName: "fallback",
                                                     abi: Web3.Utils.coldWalletABI,
                                                     parameters: [AnyObject](),
                                                     extraData: data,
                                                     value: amount,
                                                     gasPrice: gasPrice,
                                                     gasLimit: gasLimit)
    }

    // MARK: - Payment Popup

    class func showRNCustomPaymentView(toAddress: String,
                                       amount: BigUInt,
                                       height: CGFloat = 500,
                                       data: Data,
                                       success: @escaping StringBlock) {
        let topVC = UIApplication.topViewController()
        let modal = RNCustomPopUp.make(toAddress: toAddress, amount: amount,
                                       height: height, data: data, successBlock: success)
        topVC?.presentAsStork(modal, height: height)
    }

    // MARK: - Send ERC20

    class func showTokenView(token: Coin,
                             toAddress: String,
                             amount: BigUInt,
                             data: Data,
                             decimal: Int? = BlockChain.Ethereum.decimal,
                             success: @escaping StringBlock) {
        let topVC = UIApplication.topViewController()
        let modal = SendERC20PopUp.make(token: token,
                                        toAddress: toAddress,
                                        amount: amount,
                                        data: data,
                                        decimal: decimal!,
                                        success: success)
        let height = 430 - 34 + Constant.SAFE_BOTTOM
        topVC?.presentAsStork(modal, height: height)
    }

    public func sendERC20Token(tokenAddrss: String,
                               to address: String,
                               amount: BigUInt,
                               data _: Data,
                               password _: String,
                               gasPrice _: GasPrice = GasPrice.average) -> Promise<String> {
        return Promise<String> { seal in
            guard let toAddress = EthereumAddress(address),
                let token = EthereumAddress(tokenAddrss) else {
                throw WalletError.invalidAddress
            }

            let parameters = [toAddress, amount] as [AnyObject]

            firstly {
                TransactionManager.writeSmartContract(contractAddress: token.address,
                                                      functionName: "transfer",
                                                      abi: Web3.Utils.erc20ABI,
                                                      parameters: parameters,
                                                      extraData: Data(),
                                                      value: amount,
                                                      notERC20: false)
            }.done { hash in
                seal.fulfill(hash)
            }.catch { error in
                seal.reject(error)
            }
        }
    }

    // MARK: - Call Smart Contract

    public class func writeSmartContract(contractAddress: String,
                                         functionName: String,
                                         abi: String,
                                         parameters: [Any],
                                         extraData: Data,
                                         value: BigUInt,
                                         gasPrice: GasPrice = GasPrice.average,
                                         gasLimit: TransactionOptions.GasLimitPolicy = .automatic,
                                         notERC20: Bool = true) -> Promise<String> {
        return Promise<String> { seal in

            guard let address = WalletManager.currentAccount?.address else {
                seal.reject(WalletError.invalidAddress)
                return
            }

            guard let walletAddress = EthereumAddress(address) else {
                seal.reject(WalletError.invalidAddress)
                return
            }

            guard let contractAddress = EthereumAddress(contractAddress) else {
                seal.reject(WalletError.invalidAddress)
                return
            }

            guard let amountInDouble = Double(value.readableValue) else {
                seal.reject(WalletError.conversionFailure)
                return
            }

            guard let _ = WalletManager.web3Net.provider.attachedKeystoreManager else {
                seal.reject(WalletError.malformedKeystore)
                return
            }

            guard let contract = WalletManager.web3Net.contract(abi, at: contractAddress, abiVersion: 2) else {
                seal.reject(WalletError.contractFailure)
                return
            }

            let gasPrice = gasPrice.wei
            var options = TransactionOptions.defaultOptions
            options.value = notERC20 ? value : nil
            options.from = walletAddress
            options.gasPrice = .manual(gasPrice)
            options.gasLimit = gasLimit

            guard let tx = contract.write(
                functionName,
                parameters: parameters as [AnyObject],
                extraData: extraData,
                transactionOptions: options
            ) else {
                seal.reject(WalletError.contractFailure)
                return
            }

            firstly {
                TransactionManager.shared.checkBalance(amountInDouble: amountInDouble, notERC20: notERC20)
            }.then { _ in
                tx.sendPromise(password: "web3swift", transactionOptions: options)
            }.done { result in
                seal.fulfill(result.hash)
                let url = PinItem.txURL(network: WalletManager.currentNetwork,
                                        txHash: result.hash).absoluteString
                let browser = BrowserWrapperViewController.make(urlString: url)

                let pinItem = PinItem.transaction(coin: Coin.coin(chain: .Ethereum),
                                                  network: WalletManager.currentNetwork,
                                                  txHash: result.hash,
                                                  title: "Pending Transaction",
                                                  viewcontroller: browser)
                PendingTransactionHelper.shared.add(item: pinItem, track: true)

            }.catch { error in

                seal.reject(error)
            }
        }
    }

    func checkBalance(amountInDouble: Double, notERC20: Bool) -> Promise<Bool> {
        return Promise { seal in
            // TODO: Add ERC20 Blanace Check
            if !notERC20 {
                seal.fulfill(true)
            }

            firstly {
                etherBalance()
            }.done { etherBalance in
                guard let etherBalanceInDouble = Double(etherBalance) else {
                    seal.reject(WalletError.conversionFailure)
                    return
                }
                if notERC20 {
                    guard etherBalanceInDouble >= amountInDouble else {
                        seal.reject(WalletError.insufficientBalance)
                        return
                    }
                }
                seal.fulfill(true)
            }
        }
    }

    public class func readSmartContract(contractAddress: String,
                                        functionName: String,
                                        abi: String, parameters: [Any],
                                        value: String = "0.0") -> Promise<[String: Any]> {
        return Promise<[String: Any]> { seal in

            guard let address = WalletManager.currentAccount?.address else {
                throw WalletError.invalidAddress
            }

            guard let walletAddress = EthereumAddress(address) else {
                throw WalletError.invalidAddress
            }

            guard let contractAddress = EthereumAddress(contractAddress) else {
                throw WalletError.invalidAddress
            }

            let abiVersion = 2
            let extraData: Data = Data()
            let contract = WalletManager.web3Net.contract(abi, at: contractAddress, abiVersion: abiVersion)
            let amount = Web3.Utils.parseToBigUInt(value, units: .eth)

            var options = TransactionOptions.defaultOptions
            options.value = value == "0.0" ? nil : amount
            options.from = walletAddress
            options.gasPrice = .automatic
            options.gasLimit = .automatic
            guard let tx = contract!.read(
                functionName,
                parameters: parameters as [AnyObject],
                extraData: extraData,
                transactionOptions: options
            ) else {
                throw WalletError.contractFailure
            }

            firstly {
                tx.callPromise()
            }.done { result in
                seal.fulfill(result)
            }.catch { error in
                seal.reject(error)
            }
        }
    }

    // MARK: - Sign Message

    class func showSignMessageView(message: String, success: @escaping StringBlock) {
        let topVC = UIApplication.topViewController()
        let modal = SignMessagePopUp.make(message: message, success: success)
        let height = 420 - 34 + Constant.SAFE_BOTTOM
        topVC?.presentAsStork(modal, height: height)
    }

    class func signMessage(message: Data) throws -> String? {
        guard let address = WalletManager.currentAccount?.address else {
            throw WalletError.invalidAddress
        }

        guard let walletAddress = EthereumAddress(address) else {
            throw WalletError.invalidAddress
        }

        guard let keystore = WalletManager.web3Net.provider.attachedKeystoreManager else {
            throw WalletError.malformedKeystore
        }

        do {
            let signedData = try Web3Signer.signPersonalMessage(message,
                                                                keystore: keystore,
                                                                account: walletAddress,
                                                                password: Setting.password)
            return (signedData?.toHexString().addHexPrefix())!
        } catch {
            throw WalletError.messageFailedToData
        }
    }

    // MARK: - Sign Transaction

    class func showSignTransactionView(to: String,
                                       value: BigUInt,
                                       data: Data,
                                       detailObject: Bool = false,
                                       success: @escaping StringBlock) {
        let topVC = UIApplication.topViewController()
        let modal = SignTransactionPopUp.make(toAddress: to,
                                              amount: value,
                                              data: data,
                                              detailObject: detailObject,
                                              success: success)
        let height = 430 - 34 + Constant.SAFE_BOTTOM
        topVC?.presentAsStork(modal, height: height)
    }

    class func signTransaction(to address: String,
                               amount: BigUInt,
                               data: Data,
                               detailObject: Bool = false,
                               gasPrice: GasPrice = GasPrice.average) throws -> String {
        guard let toAddress = EthereumAddress(address) else {
            throw WalletError.invalidAddress
        }

        guard let address = WalletManager.currentAccount?.address else {
            throw WalletError.invalidAddress
        }

        guard let walletAddress = EthereumAddress(address) else {
            throw WalletError.invalidAddress
        }

        let etherBalance = try TransactionManager.shared.etherBalanceSync()
        guard let etherBalanceInDouble = Double(etherBalance) else {
            throw WalletError.conversionFailure
        }

        guard let amountInDouble = Double(amount.readableValue) else {
            throw WalletError.conversionFailure
        }

        guard etherBalanceInDouble >= amountInDouble else {
            throw WalletError.insufficientBalance
        }

        guard let keystore = WalletManager.web3Net.provider.attachedKeystoreManager else {
            throw WalletError.malformedKeystore
        }

        let gasPrice = gasPrice.wei
        let value = amount
        var options = TransactionOptions.defaultOptions
        options.value = value
        options.from = walletAddress
        options.gasPrice = .manual(gasPrice)
        options.gasLimit = .automatic

        var tx = EthereumTransaction(to: toAddress, data: data, options: options)
        do {
            try Web3Signer.signTX(transaction: &tx,
                                  keystore: keystore,
                                  account: walletAddress,
                                  password: Setting.password)

//            print(tx.description)
            if detailObject {
                return tx.toJsonString()
            }
            return (tx.encode(forSignature: false, chainID: nil)?.toHexString().addHexPrefix())!
        } catch {
            HUDManager.shared.showError()
        }

        return "Sign Transaction Failed"
    }

    // MARK: - Send ERC721

    class func showERC721PopUp(toAddress: String,
                               NFTModel: OpenSeaModel,
                               data _: Data = Data(),
                               success: @escaping StringBlock) {
        let topVC = UIApplication.topViewController()
        let modal = SendERC721PopUp.make(NFTModel: NFTModel, toAddress: toAddress, success: success)
        let height = 550 - 34 + Constant.SAFE_BOTTOM
        topVC?.presentAsStork(modal, height: height)
    }

    public func sendERC721Token(tokenId: String,
                                toAddress: String,
                                contractAddress: String,
                                data: Data = Data(),
                                password: String?,
                                gasPrice _: GasPrice = GasPrice.average) -> Promise<String> {
        let ETHAddress = EthereumAddress(WalletManager.currentAccount!.address)!
//        let erc = ERC721(web3: WalletManager.web3Net, provider: WalletManager.web3Net.provider, address: ETHAddress)
//        let id = BigUInt("705")
//
//        erc.readProperties()
//
//
//        do {
//
        ////            let contract = try erc.transfer(from: ETHAddress,
        ////                                            to: EthereumAddress("0xA1b02d8c67b0FDCF4E379855868DeB470E169cfB")!,
        ////                                            tokenId: id)
//            let contract = try erc.safeTransferFrom(from: ETHAddress,
//                                                    to: EthereumAddress("0x56519083C3cfeAE833B93a93c843C993bE1D74EA")!,
//                                                    originalOwner: ETHAddress,
//                                                    tokenId: id, data: [])
//
//            let result = try contract.send()
//            print("AAAAAA")
//
//            print(result.hash)
//
//        } catch let error {
//            print(error)
//        }

        return Promise<String> { seal in
            TransactionManager.writeSmartContract(contractAddress: contractAddress,
                                                  functionName: "safeTransferFrom",
                                                  abi: Web3.Utils.erc721ABI,
                                                  parameters: [WalletManager.currentAccount!.address, toAddress, tokenId, data],
                                                  extraData: Data(),
                                                  value: BigUInt(0)).done { txHash in
                seal.fulfill(txHash)
            }.catch { error in
                seal.reject(error)
            }
        }
    }

    // MARK: - Validator

//    func validator(address: String, data _: Data, value: BigUInt) throws -> Bool {
//        guard let toAddress = EthereumAddress(address) else {
//            throw WalletError.invalidAddress
//        }
//
//        guard let address = WalletManager.currentAccount?.address else {
//            throw WalletError.invalidAddress
//        }
//
//        guard let walletAddress = EthereumAddress(address) else {
//            throw WalletError.invalidAddress
//        }
//
//        let etherBalance = try TransactionManager.shared.etherBalanceSync()
//        guard let etherBalanceInDouble = Double(etherBalance) else {
//            throw WalletError.conversionFailure
//        }
//
//        guard let amountInDouble = Double(value.readableValue) else {
//            throw WalletError.conversionFailure
//        }
//
//        guard etherBalanceInDouble >= amountInDouble else {
//            throw WalletError.insufficientBalance
//        }
//
//        guard let keystore = WalletManager.web3Net.provider.attachedKeystoreManager else {
//            throw WalletError.malformedKeystore
//        }
//
//        return true
//    }
}
