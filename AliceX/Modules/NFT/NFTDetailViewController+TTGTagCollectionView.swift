//
//  NFTDetailViewController+TTGTagCollectionView.swift
//  AliceX
//
//  Created by lmcmz on 18/1/20.
//  Copyright © 2020 lmcmz. All rights reserved.
//

import Foundation

extension NFTDetailViewController: TTGTagCollectionViewDelegate, TTGTagCollectionViewDataSource {
    
    func tagCollectionView(_ tagCollectionView: TTGTagCollectionView!, sizeForTagAt index: UInt) -> CGSize {
        return tagView![Int(index)].frame.size
    }
    
    func numberOfTags(in tagCollectionView: TTGTagCollectionView!) -> UInt {
        guard let model = self.model, let traits = model.traits, traits.count > 0 else {
            return 0
        }
        return UInt(traits.count)
    }
    
    func tagCollectionView(_ tagCollectionView: TTGTagCollectionView!, tagViewFor index: UInt) -> UIView! {
        return tagView![Int(index)]
    }
    
}
