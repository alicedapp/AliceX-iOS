//
//  AssetViewController.swift
//  AliceX
//
//  Created by lmcmz on 26/10/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import ESPullToRefresh
import Haneke
import PromiseKit
import SPStorkController
import SwiftyUserDefaults
import UIKit
import ViewAnimator

class AssetViewController: BaseViewController {
    @IBOutlet var navLabel: UILabel!
    @IBOutlet var navLine: UIView!
    @IBOutlet var navBar: UIView!
    @IBOutlet var collectionView: UICollectionView!

    var coins: [Coin]! = []
    var NFTData: [OpenSeaModel]! = []

    var coinHide: Bool = false
    var NFTHide: Bool = false
    var assetHide: Bool = false

    var balance: Double?

    let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
    let coinAnimations = [AnimationType.from(direction: .right, offset: 100.0)]

    override func viewDidLoad() {
        super.viewDidLoad()

        assetHide = Defaults[\.isHideAsset]

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        collectionView.alwaysBounceVertical = true

        for cell in Asset.allCases {
            collectionView.registerCell(nibName: cell.name)
        }

        loadFromCache()
        requestData()

        NotificationCenter.default.addObserver(self, selector: #selector(listChange), name: .watchingCoinListChange, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(requestData), name: .currencyChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestData), name: .walletChange, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(requestData), name: .networkChange, object: nil)

        let animator = AssetImgeAnimator(frame: CGRect.zero)
        collectionView.es.addPullToRefresh(animator: animator, handler: {
            self.requestData()
        })

        coins = WatchingCoinHelper.shared.list
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func requestData() {
        if let doubleBalance = self.balance {
            Defaults[\.lastAssetBalance] = doubleBalance
        }

        firstly {
            WatchingCoinHelper.shared.update()
        }.done { _ in
//            self.coins = WatchingCoinHelper.shared.list
//            self.collectionView.reloadData()
//            self.lastUpdateDate = Date()
            Defaults[\.lastTimeUpdateAsset] = Date()

            var balance = 0.0
            for coin in WatchingCoinHelper.shared.list {
                guard let info = coin.info else {
                    continue
                }
                balance += info.balance
            }
            self.balance = balance

        }.ensure {
            self.coins = WatchingCoinHelper.shared.list
            self.collectionView.reloadData()
            self.collectionView.es.stopPullToRefresh()
        }.catch { error in
            print("AAA: - \(error.localizedDescription)")
//            self.collectionView.es.stopPullToRefresh()
        }

        requestNFT()
    }

    func loadFromCache() {
        firstly {
            when(fulfilled: CoinInfoCenter.shared.loadFromCache(), WatchingCoinHelper.shared.loadFromCache())
        }.done { _ in
            IgnoreCoinHelper.shared.loadFromCache()
            self.coins = WatchingCoinHelper.shared.list
//            self.collectionView.reloadData()
//            self.collectionView.reloadSections(IndexSet(arrayLiteral: Asset.coinHeader.rawValue))
            self.coinSectionShowAnimation()
            self.collectionView.reloadSections(IndexSet(arrayLiteral: Asset.balance.rawValue))
        }.catch { error in
            IgnoreCoinHelper.shared.loadFromCache()
            self.coins = WatchingCoinHelper.shared.list
//            self.collectionView.reloadData()
//            self.collectionView.reloadSections(IndexSet(arrayLiteral: Asset.balance.rawValue))
            self.coinSectionShowAnimation()
            self.collectionView.reloadSections(IndexSet(arrayLiteral: Asset.balance.rawValue))
            print(error)
        }

        let cacheKey = "\(CacheKey.assetNFTKey).\(WalletManager.wallet!.address)"
        Shared.stringCache.fetch(key: cacheKey).onSuccess { string in
            guard let model = OpenSeaReponse.deserialize(from: string) else {
                return
            }
            self.NFTData = model.assets
            self.NFTSectionShowAimation()
        }
    }

    @IBAction func settingClick() {
        let vc = SettingViewController()
        let navi = BaseNavigationController(rootViewController: vc)
//        let transitionDelegate = SPStorkTransitioningDelegate()
//        navi.transitioningDelegate = transitionDelegate
//        navi.modalPresentationStyle = .custom
        presentAsStork(navi, height: nil, showIndicator: false, showCloseButton: false)
    }

    @IBAction func addressButtonClick() {
        let vc = AddressQRCodeViewController()
        vc.selectBlockCahin = .Ethereum
//        vc.modalPresentationStyle = .overCurrentContext
//        present(vc, animated: true, completion: nil)
        HUDManager.shared.showAlertVCNoBackground(viewController: vc)
    }

    func requestCoins() -> Promise<Void> {
        return Promise<Void> { seal in

            firstly {
                WatchingCoinHelper.shared.update()
            }.done { _ in
//                self.coins = WatchingCoinHelper.shared.list
//                self.collectionView.reloadData()
                seal.fulfill(())
            }.catch { error in
//                self.coins = WatchingCoinHelper.shared.list
//                self.collectionView.reloadData()
                seal.reject(error)
            }
        }
    }

    func requestNFT() -> Promise<Bool> {
        let currentAddress = WalletManager.wallet!.address

        let cacheKey = "\(CacheKey.assetNFTKey).\(currentAddress)"

        return Promise<Bool> { seal in

            firstly { () -> Promise<OpenSeaReponse> in
                API(OpenSea.assets(address: currentAddress))
            }.done { model in

                var hasNew = true
                if self.NFTData != nil {
                    hasNew = model.assets!.count > self.NFTData.count
                }
                self.NFTData = model.assets?.filter({ asset -> Bool in
                    asset.image_preview_url != nil
                })
                Shared.stringCache.set(value: model.toJSONString()!, key: cacheKey)
//                if hasNew {
//                    self.NFTSectionAimation()
//                } else {
//                    self.collectionView.reloadSections(IndexSet(integer: Asset.NFT.rawValue))
//                }

                self.collectionView.reloadData()

                seal.fulfill(true)
            }.catch { error in
                print("Fetch NFT failed")
                seal.reject(error)
            }
        }
    }

//    @objc func priceUpdate() {
//        collectionView.reloadSections(IndexSet(arrayLiteral: Asset.coin.rawValue))
//    }

    @objc func listChange() {
        coins = WatchingCoinHelper.shared.list
        collectionView.reloadData()
//        requestData()
//        watchChains = WatchingCoinHelper.shared.blockchainList()
//        collectionView.reloadSections(IndexSet(arrayLiteral: Asset.coin.rawValue, Asset.erc20.rawValue))
    }
}
