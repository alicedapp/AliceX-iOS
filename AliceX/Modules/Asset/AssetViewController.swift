//
//  AssetViewController.swift
//  AliceX
//
//  Created by lmcmz on 26/10/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Haneke
import PromiseKit
import SPStorkController
import UIKit
import ESPullToRefresh
import ViewAnimator

class AssetViewController: BaseViewController {
    @IBOutlet var navLabel: UILabel!
    @IBOutlet var navLine: UIView!
    @IBOutlet var navBar: UIView!
    @IBOutlet var collectionView: UICollectionView!

    var watchChains: [BlockChain] = []
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
        requestData()

        NotificationCenter.default.addObserver(self, selector: #selector(priceUpdate), name: .priceUpdate, object: nil)
//
//        collectionView.es.addPullToRefresh {
//            self.requestData()
//        }
        
        let animator = AssetImgeAnimator.init(frame: CGRect.zero)
        collectionView.es.addPullToRefresh(animator: animator, handler: {
            self.requestData()
        })
        
        watchChains = WatchingCoinHelper.shared.blockchainList()
    }
    
    func requestData() {
        firstly {
            when(fulfilled: requestNFT(), requestERC20())
        }.done { (_, _) in
//            self.collectionView.es.stopPullToRefresh()
//            self.collectionView.editing
            self.watchChains = WatchingCoinHelper.shared.blockchainList()
            self.collectionView.reloadSections(IndexSet(integer: Asset.erc20.rawValue))
        }.ensure {
            self.collectionView.es.stopPullToRefresh()
        }.catch { error in
//            self.collectionView.es.stopPullToRefresh()
        }
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
    
    @IBAction func addressButtonClick() {
        let vc = AddressQRCodeViewController()
        vc.selectBlockCahin = .Binance
//        present(vc, animated: true, completion: nil)
        HUDManager.shared.showAlertVCNoBackground(viewController: vc)
    }

    func requestERC20() -> Promise<Bool> {
        
        return Promise<Bool> { seal in
            firstly { () -> Promise<AddressInfo> in
                API(Ethplorer.getAddressInfo(address: "0xa1b02d8c67b0fdcf4e379855868deb470e169cfb"))
            }.done { model in
                
                if model.error != nil {
                    throw WalletError.custom("Ethplorer error")
                }
                
                var hasNew = true
                if self.erc20Data != nil {
                    hasNew = model.tokens.count > self.erc20Data.tokens.count
                }
                self.erc20Data = model
                Shared.stringCache.set(value: model.toJSONString()!, key: CacheKey.assetERC20Key)
                if hasNew {
                    self.erc20SectionAimation()
                } else {
                    self.collectionView.reloadSections(IndexSet(integer: Asset.erc20.rawValue))
                }
                
                seal.fulfill(true)
                
//                if WatchingCoinHelper.shared.isEmpty {
                    model.tokens.forEach { item in
                        let token = ERC20(item: item)
                        let coin = Coin.ERC20(token: token)
                        WatchingCoinHelper.shared.add(coin: coin)
                    }
//                } else {
//                    //TODO
//                }
                
            }.catch { error in
                print("Fetch ECR20 failed")
                seal.reject(error)
            }
        }
    }

    func requestNFT() -> Promise<Bool> {
        
        return Promise<Bool> { seal in
        
            firstly { () -> Promise<OpenSeaReponse> in
                API(OpenSea.assets(address: "0xa1b02d8c67b0fdcf4e379855868deb470e169cfb"))
            }.done { model in
                
                var hasNew = true
                if self.NFTData != nil {
                    hasNew = model.assets!.count > self.NFTData.count
                }
                self.NFTData = model.assets
                Shared.stringCache.set(value: model.toJSONString()!, key: CacheKey.assetNFTKey)
                if hasNew {
                    self.NFTSectionAimation()
                } else {
                    self.collectionView.reloadSections(IndexSet(integer: Asset.NFT.rawValue))
                }
                
                seal.fulfill(true)
            }.catch { error in
                print("Fetch NFT failed")
                seal.reject(error)
            }
        }
    }

    @objc func priceUpdate() {
        collectionView.reloadSections(IndexSet(arrayLiteral: Asset.coin.rawValue))
    }
}
