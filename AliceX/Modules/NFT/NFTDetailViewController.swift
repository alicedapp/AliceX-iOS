//
//  NFTDetailViewController.swift
//  AliceX
//
//  Created by lmcmz on 17/1/20.
//  Copyright © 2020 lmcmz. All rights reserved.
//

import UIKit
import Kingfisher
import web3swift
import BigInt
import PromiseKit
import MarqueeLabel

class NFTDetailViewController: BaseViewController {

    @IBOutlet var NFTImageView: UIImageView!
    @IBOutlet var contractImageView: UIImageView!
    @IBOutlet var OpenSeaImageView: UIImageView!
    
    @IBOutlet var contractIndicator: UIImageView!
    @IBOutlet var OpenSeaIndicator: UIImageView!
    
    @IBOutlet var contractLabel: UILabel!
    @IBOutlet var nameLabel: MarqueeLabel!
    @IBOutlet var descTextView: UITextView!
    
    @IBOutlet var priceNameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var NFTScrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    
    @IBOutlet var traitsView: UIView!
    
    @IBOutlet var textViewHeight: NSLayoutConstraint!
    
    @IBOutlet var collectionView: UICollectionView!
    
    var tagView: [UIView]? = []
    
    var model: OpenSeaModel?
    
    lazy var addressVC: AddressPopUp = {
        let vc = AddressPopUp.make(delegate: self, address: nil)
        return vc
    }()
    
    class func make(NFTModel: OpenSeaModel) -> NFTDetailViewController {
        let vc = NFTDetailViewController()
        vc.model = NFTModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        guard let model = self.model else {
            return
        }
        
        NFTScrollView.delegate = self
        
        scrollView.alwaysBounceVertical = true
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        
        if let name = model.name, !name.isEmptyAfterTrim() {
            nameLabel.text = name
        } else {
            nameLabel.text = "(No Name)"
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
            NFTImageView.backgroundColor = AliceColor.white()
//                UIColor(hex: "D5D5D5", alpha: 0.15)
        }
        
//        traitsView.backgroundColor = NFTImageView.backgroundColor

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
        
        OpenSeaIndicator.image = OpenSeaIndicator.image?.filled(with: UIColor(hex: "3291E9"))
        
        descTextView.text = model.description ?? "(No Description)"
        contractLabel.text = model.asset_contract?.name
        descTextView.translatesAutoresizingMaskIntoConstraints = false
        descTextView.isScrollEnabled = false
        descTextView.sizeToFit()
        textViewHeight.constant = descTextView.contentSize.height
        
//        contractAddressLabel.text = model?.asset_contract?.address
        
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
        
        contractIndicator.isHidden = model.asset_contract?.external_link?.isEmpty ?? true
        
        if let traits = model.traits, traits.count > 0 {
            pageControl.numberOfPages = 2
            NFTScrollView.isScrollEnabled = true
            
            for trait in traits {
//                let view = TraitView.instanceFromNib()
//                view.translatesAutoresizingMaskIntoConstraints = false
//                view.configure(type: trait.trait_type, name: trait.value)
                let view = viewForTratis(model: trait)
                tagView?.append(view)
            }
            
            collectionView.backgroundColor = NFTImageView.backgroundColor
            
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.registerCell(nibName: TraitCell.nameOfClass)
            collectionView.collectionViewLayout = TagCellLayout(alignment: .center, delegate: self)
            
        } else {
            pageControl.numberOfPages = 1
            NFTScrollView.isScrollEnabled = false
        }
    }
    
    @IBAction func contractClick() {
        
        guard let model = self.model, let contract = model.asset_contract,
            let url = contract.external_link else {
            return
        }
        
        let vc = BrowserWrapperViewController.make(urlString: url)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func openSeaClick() {
        
        guard let model = self.model, let url = model.permalink else {
            return
        }
        
        let vc = BrowserWrapperViewController.make(urlString: url)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func addressButtonClick() {
        let vc = AddressQRCodeViewController()
        vc.selectBlockCahin = .Ethereum
        HUDManager.shared.showAlertVCNoBackground(viewController: vc, haveBG: true)
    }
    
    @IBAction func sendButtonClick() {
        let vc = addressVC
        vc.modalPresentationStyle = .overCurrentContext
        UIApplication.topViewController()?.present(vc, animated: false, completion: nil)
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
}

extension NFTDetailViewController: AddressPopUpDelegate {
    
    func comfirmedAddress(address: String) {

        guard let model = self.model else {
            return
        }
        
        TransactionManager.showERC721PopUp(toAddress: address,
                                           NFTModel: model) { txHash in
                                            self.addressVC.cancelBtnClicked()
        }
    }
    
}

extension NFTDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let x = scrollView.contentOffset.x
        
        if x > Constant.SCREEN_WIDTH/2 {
            pageControl.currentPage = 1
        } else {
            pageControl.currentPage = 0
        }
    }
}
