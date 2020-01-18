//
//  SendERC721PopUp.swift
//  AliceX
//
//  Created by lmcmz on 17/1/20.
//  Copyright © 2020 lmcmz. All rights reserved.
//

import BigInt
import Kingfisher
import PromiseKit
import UIKit
import web3swift
import MarqueeLabel

class SendERC721PopUp: UIViewController {
    @IBOutlet var payButton: UIControl!

    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var nameLabel: MarqueeLabel!
    @IBOutlet var descLabel: MarqueeLabel!
    @IBOutlet var contractLabel: MarqueeLabel!
    @IBOutlet var contractAddressLabel: MarqueeLabel!
    
    @IBOutlet var priceNameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    
    @IBOutlet var NFTImageView: UIImageView!
    @IBOutlet var contractImageView: UIImageView!

    @IBOutlet var gasPriceLabel: UILabel!
    @IBOutlet var gasTimeLabel: UILabel!
    @IBOutlet var gasBtn: UIControl!

    var toAddress: String!
    var amount: BigUInt = BigUInt(0)
    var data: Data = Data()

    var gasLimit: BigUInt?
    var gasPrice: GasPrice = GasPrice.average
    var successBlock: StringBlock!
    var tokenInfo: TokenInfo?
    var payView: PayButtonView?

    var NFTModel: OpenSeaModel!

    class func make(NFTModel: OpenSeaModel,
                    toAddress: String,
                    success: @escaping StringBlock) -> SendERC721PopUp {
        let vc = SendERC721PopUp()
        vc.NFTModel = NFTModel
        vc.toAddress = toAddress
        vc.successBlock = success
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        payView = PayButtonView.instanceFromNib()
        payButton.addSubview(payView!)
        payView!.fillSuperview()
        payView?.delegate = self
        
        addressLabel.text = toAddress
        
        if let name = NFTModel.name {
            nameLabel.text = name
        }
        
        guard let model = self.NFTModel else{
            return
        }
        
        if let image = model.image_url, let imageURL = URL(string: image) {
            if image.hasSuffix(".svg") {
                NFTImageView.kf.setImage(with: URL(string: (model.image_preview_url!))!)
            } else {
                NFTImageView.kf.setImage(with: imageURL)
            }
        } else {
            NFTImageView.image = nil
        }

        if let color = model.background_color {
            NFTImageView.backgroundColor = UIColor(hex: color)
        } else {
            NFTImageView.backgroundColor = UIColor(hex: "D5D5D5", alpha: 0.15)
        }

        if let image = model.asset_contract!.image_url, let imageURL = URL(string: image) {
            contractImageView.kf.setImage(with: imageURL) { result in
                switch result {
                case .success:
                    self.contractImageView.backgroundColor = .clear
                default:
                    break
                }
            }
        } else {
            contractImageView.image = nil
        }
        
        if let lastSell = model.last_sale, let payment_token = lastSell.payment_token {
            var price = BigUInt(lastSell.total_price!)
            let priceStr = Web3Utils.formatToPrecision(price!,
                                                       numberDecimals: payment_token.decimals!,
                                                       formattingDecimals: 4,
                                                       decimalSeparator: ".",
                                                       fallbackToScientific: true)!
            priceLabel.text = "\(priceStr) \(payment_token.symbol!)"
            priceNameLabel.text = "Last Sale Price"
        } else {
            priceNameLabel.text = "Token ID"
            priceLabel.text = model.token_id
        }

        descLabel.text =  model.description
        contractLabel.text = model.asset_contract?.name
        contractAddressLabel.text = model.asset_contract?.address
        
        gasBtn.isUserInteractionEnabled = false

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(gasChange(_:)),
                                               name: .gasSelectionCahnge, object: nil)
        
        firstly {
            GasPriceHelper.shared.getGasPrice()
        }.then {
            TransactionManager.shared.gasForContractMethod(to: (model.asset_contract?.address)!,
                                                           contractABI: Web3.Utils.erc721ABI,
                                                           methodName: "safeTransferFrom",
                                                           methodParams: [WalletManager.currentAccount!.address, self.toAddress.ethAddress!, model.token_id, Data()] as [AnyObject],
                                                           amount: self.amount,
                                                           data: self.data)
        }.done { gasLimit in
            self.gasLimit = gasLimit
            self.gasPriceLabel.text = self.gasPrice.toCurrencyFullString(gasLimit: gasLimit)
            self.gasBtn.isUserInteractionEnabled = true
            self.gasTimeLabel.text = "Arrive in ~ \(self.gasPrice.time) mins"
        }.catch { _ in
            self.gasPriceLabel.text = "Failed to get gas"
            self.gasPriceLabel.textColor = UIColor(hex: "FF7E79")
        }
        
    }
    
    @IBAction func gasButtonClick() {
        let vc = GasFeeViewController.make(gasLimit: gasLimit!)
        HUDManager.shared.showAlertVCNoBackground(viewController: vc)
    }

    @objc func gasChange(_ notification: Notification) {
        guard let text = notification.userInfo?["gasPrice"] as? String,
            let gasPrice = GasPrice.make(string: text) else { return }
        self.gasPrice = gasPrice
        updateGas()
    }

    func updateGas() {
        gasTimeLabel.text = "Arrive in ~ \(gasPrice.time) mins"
        gasPriceLabel.text = gasPrice.toCurrencyFullString(gasLimit: gasLimit!)
    }
}

extension SendERC721PopUp: PayButtonDelegate {
    func verifyAndSend() {
        #if DEBUG
            send()
        #else
            biometricsVerify()
        #endif
    }

    func biometricsVerify() {
        firstly {
            FaceIDHelper.shared.faceID()
        }.done { _ in
            self.send()
        }
    }

    func send() {

        payView!.showLoading()

        firstly {
            
            TransactionManager.shared.sendERC721Token(tokenId: NFTModel.token_id,
                                                      toAddress: toAddress,
                                                      contractAddress: NFTModel.asset_contract!.address,
                                                      password: "")
            
        }.done { hash in
            print(hash)
            self.successBlock!(hash)
            self.dismiss(animated: true, completion: nil)
        }.catch { error in
            self.payView!.failed()
            HUDManager.shared.showError(error: error)
        }
    }
}
