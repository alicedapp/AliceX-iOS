//
//  AddressPopUp.swift
//  AliceX
//
//  Created by lmcmz on 18/1/20.
//  Copyright © 2020 lmcmz. All rights reserved.
//

import UIKit

protocol AddressPopUpDelegate {
    func comfirmedAddress(address: String)
}

class AddressPopUp: UIViewController {

    @IBOutlet var addressField: UITextField!
    
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var ensAddressLabel: UILabel!

    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var containView: UIView!
    @IBOutlet var bgView: UIView!
    
    var NFTModel: OpenSeaModel?
    var address: String?
    let coin = Coin.coin(chain: .Ethereum)
    
    var delegate: AddressPopUpDelegate?
    
    class func make(delegate: AddressPopUpDelegate, address: String?) -> AddressPopUp {
        let vc = AddressPopUp()
        vc.address = address
        vc.delegate = delegate
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressField.text = address
//        self.addressField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)

        containView.transform = CGAffineTransform(translationX: 0, y: -400)
        bgView.alpha = 0

        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: {
                           self.bgView.alpha = 1
                           self.containView.transform = CGAffineTransform.identity
                       }, completion: { _ in
                        self.addressField.becomeFirstResponder()
        })
    }
    
    @IBAction func cancelBtnClicked() {
        view.endEditing(true)
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: {
                           self.bgView.alpha = 0
                           self.containView.transform = CGAffineTransform(translationX: 0, y: -400)
                       }, completion: { _ in
                           self.dismiss(animated: false, completion: nil)
        })
    }

    @IBAction func pasteBtnClicked() {
        let address = UIPasteboard.general.string
        guard let addr = address,
            coin.verify(address: addr.trimmingCharacters(in: .whitespacesAndNewlines)) else {
            if !coin.isERC20, coin != Coin.coin(chain: .Ethereum) {
                errorAlert(text: "Address invalid")
            }
            addressField.text = address?.trimmingCharacters(in: .whitespacesAndNewlines)
            self.address = address?.trimmingCharacters(in: .whitespacesAndNewlines)
            addressFieldDidChange(addressField)
            return
        }
        addressField.text = addr.trimmingCharacters(in: .whitespacesAndNewlines)
        self.address = address?.trimmingCharacters(in: .whitespacesAndNewlines)
        addressFieldDidChange(addressField)
    }
    
    @IBAction func confirmBtnClicked() {
        guard let addr = self.address, coin.verify(address: addr) else {
            errorAlert(text: "Address invalid")
            return
        }
        
        if let delegate = self.delegate {
            delegate.comfirmedAddress(address: addr)
//            cancelBtnClicked()
//            HUDManager.shared.dismiss()
        }
    }
    
    @IBAction func cameraBtnClicked() {
        let vc = QRCodeReaderViewController.make { result in
            let trimStr = result.trimmingCharacters(in: .whitespacesAndNewlines)
            if !self.coin.verify(address: trimStr) {
                self.errorAlert(text: "Address invalid")
                self.addressField.text = trimStr
                self.address = trimStr
                self.addressFieldDidChange(self.addressField)
                return
            }
            self.addressField.text? = trimStr
            self.address = trimStr
            self.addressFieldDidChange(self.addressField)
        }
        present(vc, animated: true, completion: nil)
    }
    

    @IBAction func addressFieldDidChange(_ textField: UITextField) {
        let coin = Coin.coin(chain: .Ethereum)
        
        addressLabel.text = "Address"
        ensAddressLabel.text = ""

//        if let addStr = textField.text {
//            self.address = addStr.trimmingCharacters(in: .whitespacesAndNewlines)
//        }

        address = textField.text

        if !coin.isERC20, coin != Coin.coin(chain: .Ethereum) {
            return
        }

        guard let text = textField.text else {
            return
        }

        if !text.contains(".") {
            return
        }

        addressLabel.text = "Fetching ENS ..."

        onBackgroundThread {
            WalletManager.shared.getENSAddressWithPromise(node: text).done { EthAddress in
                onMainThread {
                    self.addressLabel.text = "Address ✅"
                    self.ensAddressLabel.text = EthAddress.address
                    self.address = EthAddress.address
                }

            }.catch { _ in
                onMainThread {
//                    self.errorAlert(text: error.localizedDescription)
                    self.addressLabel.text = "Address ❌"
                }
            }
        }
    }
    
    // MARK: - Error

    func errorAlert(text: String) {
        errorAnimation()
        titleLabel.text = text
        titleLabel.textColor = Color.red
        delay(3) {
            self.errorAnimation()
            self.titleLabel.text = "Transfer NFT"
            self.titleLabel.textColor = UIColor.lightGray
        }
    }

    func errorAnimation() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        transition.type = CATransitionType(rawValue: "cube")
        transition.subtype = CATransitionSubtype.fromBottom
        titleLabel.layer.add(transition, forKey: "country1_animation")
//        transition.subtype = CATransitionSubtype.fromTop
//        country2.layer.add(transition, forKey: "country2_animation")
    }
}
