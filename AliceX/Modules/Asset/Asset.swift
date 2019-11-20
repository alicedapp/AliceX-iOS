//
//  Asset.swift
//  AliceX
//
//  Created by lmcmz on 27/10/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation

enum Asset: Int, CaseIterable {
    case balance = 0
    case coinHeader
    case coin
    case emptyCoin
    case NFTHeader
    case NFT
}

extension Asset {
    var cell: UICollectionReusableView {
        switch self {
        case .balance:
            return AssetBalanceCell()
        case .coinHeader:
            return AssetCoinHeaderCell()
        case .coin:
            return AssetCoinCell()
        case .emptyCoin:
            return AddCoinCell()
        case .NFTHeader:
            return AssetNFTHeaderCell()
        case .NFT:
            return AssetNFTCell()
        }
    }

    var name: String {
        switch self {
        case .balance:
            return AssetBalanceCell.nameOfClass
        case .coinHeader:
            return AssetCoinHeaderCell.nameOfClass
        case .coin:
            return AssetCoinCell.nameOfClass
        case .emptyCoin:
            return AddCoinCell.nameOfClass
        case .NFTHeader:
            return AssetNFTHeaderCell.nameOfClass
        case .NFT:
            return AssetNFTCell.nameOfClass
        }
    }

    var size: CGSize {
        switch self {
        case .balance:
            return CGSize(width: Constant.SCREEN_WIDTH, height: 200)
        case .coinHeader:
            return CGSize(width: Constant.SCREEN_WIDTH, height: 65)
        case .coin:
            return CGSize(width: Constant.SCREEN_WIDTH, height: 80)
        case .emptyCoin:
            return CGSize(width: Constant.SCREEN_WIDTH, height: 80)
        case .NFTHeader:
            return CGSize(width: Constant.SCREEN_WIDTH, height: 65)
        case .NFT:
            let len = (Constant.SCREEN_WIDTH - 40) / 2 - 1
            return CGSize(width: len, height: len + 10)
        }
    }
}
