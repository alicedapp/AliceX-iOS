//
//  AssetViewController.swift
//  AliceX
//
//  Created by lmcmz on 26/10/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit
import SPStorkController
import PromiseKit
import Haneke

import ViewAnimator

class AssetViewController: BaseViewController {

    @IBOutlet var navLabel: UILabel!
    @IBOutlet var navLine: UIView!
    @IBOutlet var navBar: UIView!
    @IBOutlet var collectionView: UICollectionView!
    
    var erc20Data: AddressInfo!
    var NFTData: [OpenSeaModel]!
    
    var coinHide: Bool = false
    var NFTHide: Bool = false
    
    let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
    let coinAnimations = [AnimationType.from(direction: .right, offset: 100.0)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        
        for cell in Asset.allCases {
            collectionView.registerCell(nibName: cell.name)
        }
        
        loadFromCache()
        
        requestERC20()
        requestNFT()
        
        NotificationCenter.default.addObserver(self, selector: #selector(priceUpdate), name: .priceUpdate, object: nil)
    }
    
    func loadFromCache() {
        Shared.stringCache.fetch(key: CacheKey.assetERC20Key).onSuccess { string in
            guard let model = AddressInfo.deserialize(from: string) else {
                return
            }
            self.erc20Data = model
            self.erc20SectionAimation()
        }
        
        Shared.stringCache.fetch(key: CacheKey.assetNFTKey).onSuccess { string in
            guard let model = OpenSeaReponse.deserialize(from: string) else {
                return
            }
            self.NFTData = model.assets
            self.NFTSectionAimation()
        }
        
    }

    @IBAction func settingClick() {
        let vc = SettingViewController()
        let navi = BaseNavigationController(rootViewController: vc)
        let transitionDelegate = SPStorkTransitioningDelegate()
        navi.transitioningDelegate = transitionDelegate
        navi.modalPresentationStyle = .custom
        presentAsStork(navi, height: nil, showIndicator: false, showCloseButton: false)
    }
    
    func requestERC20() {
        firstly { () -> Promise<AddressInfo> in
            API(Ethplorer.getAddressInfo(address: "0xa1b02d8c67b0fdcf4e379855868deb470e169cfb"))
        }.done { model in
            var hasNew = true
            if self.erc20Data != nil {
                hasNew = model.tokens.count > self.erc20Data.tokens.count
            }
            self.erc20Data = model
            Shared.stringCache.set(value: model.toJSONString()!, key: CacheKey.assetERC20Key)
            if hasNew {
                self.erc20SectionAimation()
            } else {
                self.collectionView.reloadSections(IndexSet(integer: Asset.coin.rawValue))
            }
        }.catch { error in
            print("Fetch ECR20 failed")
        }
    }
    
    func requestNFT() {
        firstly { () -> Promise<OpenSeaReponse> in
            API(OpenSea.assets(address: "0xa1b02d8c67b0fdcf4e379855868deb470e169cfb"))
        }.done { model in
            var hasNew = true
            if self.erc20Data != nil {
                hasNew = model.assets!.count > self.NFTData.count
            }
            self.NFTData = model.assets
            Shared.stringCache.set(value: model.toJSONString()!, key: CacheKey.assetNFTKey)
            if hasNew {
                self.NFTSectionAimation()
            } else {
                self.collectionView.reloadSections(IndexSet(integer: Asset.NFT.rawValue))
            }
        }.catch { error in
            print("Fetch NFT failed")
        }
    }
    
    @objc func priceUpdate() {
        collectionView.reloadSections(IndexSet(arrayLiteral: Asset.coin.rawValue))
    }
}
