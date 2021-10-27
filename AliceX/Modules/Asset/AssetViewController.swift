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
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        collectionView.alwaysBounceVertical = true

        for cell in Asset.allCases {
            collectionView.registerCell(nibName: cell.name)
        }

        loadFromCache().done {
            self.requestData()
        }.catch { error in
            if !Defaults[\.isFirstTimeOpen] {
                HUDManager.shared.showError(error: error)
            }

            self.cleanCache()
            self.requestData()
        }

        NotificationCenter.default.addObserver(self, selector: #selector(listChange), name: .watchingCoinListChange, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(refreshWithAnimation), name: .accountChange, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(requestData), name: .currencyChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshWithAnimation), name: .walletChange, object: nil)

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

    @objc func refreshWithAnimation() {
        collectionView.es.startPullToRefresh()
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

    func loadFromCache() -> Promise<Void> {
        return Promise<Void> { seal in
            firstly {
                when(fulfilled: CoinInfoCenter.shared.loadFromCache(),
                     WatchingCoinHelper.shared.loadFromCache(),
                     loadNTFFromCache())
            }.ensure {
                IgnoreCoinHelper.shared.loadFromCache()
                self.coins = WatchingCoinHelper.shared.list
                self.coinSectionShowAnimation()
                self.collectionView.reloadSections(IndexSet(arrayLiteral: Asset.balance.rawValue))
                Defaults[\.isFirstTimeOpen] = false
            }.done { _ in
                seal.fulfill(())
            }.catch { error in
                if !Defaults[\.isFirstTimeOpen] {
                    print(error)
                    seal.reject(error)
                }
            }
        }
    }

    func loadNTFFromCache() -> Promise<Void> {
        return Promise<Void> { seal in
            let cacheKey = "\(CacheKey.assetNFTKey).\(WalletManager.currentAccount!.address)"
            Shared.stringCache.fetch(key: cacheKey).onSuccess { string in
                guard let model = OpenSeaReponse.deserialize(from: string) else {
                    seal.fulfill(())
                    return
                }
                self.NFTData = model.assets
                self.NFTSectionShowAimation()
                seal.fulfill(())
            }.onFailure { error in
                if !Defaults[\.isFirstTimeOpen] {
                    seal.reject(error ?? MyError.FoundNil("Cache Failed in NFT"))
                }
                seal.fulfill(())
            }
        }
    }

    func cleanCache() {
        let cacheKey = "\(CacheKey.assetNFTKey).\(WalletManager.currentAccount!.address)"
        Shared.stringCache.remove(key: cacheKey)
        WatchingCoinHelper.shared.removeCache()
    }

    @IBAction func settingClick() {
        //        let vc = SettingViewController()
        //        let navi = BaseNavigationController(rootViewController: vc)
        //        presentAsStork(navi, height: nil, showIndicator: false, showCloseButton: false)

        let vc = QRCodeReaderViewController.make { result in
            if result.isValidURL {
                let vc = BrowserWrapperViewController.make(urlString: result)
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                HUDManager.shared.showErrorAlert(text: result, isAlert: true)
            }
        }
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
        //        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func addressButtonClick() {
        let vc = AddressQRCodeViewController()
        vc.selectBlockCahin = .Ethereum
        //        vc.modalPresentationStyle = .overCurrentContext
        //        present(vc, animated: true, completion: nil)
        HUDManager.shared.showAlertVCNoBackground(viewController: vc, haveBG: true)
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
        let currentAddress = WalletManager.currentAccount!.address

        let cacheKey = "\(CacheKey.assetNFTKey).\(currentAddress)"

        return Promise<Bool> { seal in

            firstly { () -> Promise<OpenSeaReponse> in
                API(OpenSea.assets(address: currentAddress))
            }.done { model in
                guard let assets = model.assets else {
                    return
                }

                self.NFTData = assets.filter({ asset -> Bool in
                    asset.image_preview_url != nil
                })

                Shared.stringCache.set(value: model.toJSONString()!, key: cacheKey)
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
