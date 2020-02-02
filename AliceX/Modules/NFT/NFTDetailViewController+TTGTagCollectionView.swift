//
//  NFTDetailViewController+TTGTagCollectionView.swift
//  AliceX
//
//  Created by lmcmz on 18/1/20.
//  Copyright © 2020 lmcmz. All rights reserved.
//

import Foundation

extension NFTDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         guard let model = self.model, let traits = model.traits, traits.count > 0 else {
            return 0
        }
        return traits.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TraitCell.nameOfClass, for: indexPath) as! TraitCell
        
        if let model = self.model, let traits = model.traits {
            let trait = traits[indexPath.item]
            cell.configure(type: trait.trait_type, name: trait.value)
        }
        return cell
        
    }
}

extension NFTDetailViewController: TagCellLayoutDelegate {
    
    func tagCellLayoutTagSize(layout: TagCellLayout, atIndex index:Int) -> CGSize {
        
        if let model = self.model, let traits = model.traits {
            let trait = traits[index]
            
            let valueLabel = UILabel()
            valueLabel.font = UIFont(name: "HelveticaNeue", size: 15)!
            valueLabel.textAlignment = .left
            valueLabel.text = trait.value
            valueLabel.sizeToFit()
            
            let typeLabel = UILabel()
            typeLabel.font = UIFont.init(name: "HelveticaNeue-Medium", size: 10)
            valueLabel.textAlignment = .left
            typeLabel.text = trait.trait_type?.split(separator: "_")
                .compactMap { String($0).firstCapitalized }
                .joined(separator: "").camelCaseToWords().uppercased()
            typeLabel.sizeToFit()
            
            let len = max(valueLabel.frame.width, typeLabel.frame.width)
            
            return CGSize(width: len + 16 + 20, height: 65)
        }
        
        return CGSize(width: 120, height: 65)
    }
    
}

//extension NFTDetailViewController: TTGTagCollectionViewDelegate, TTGTagCollectionViewDataSource {
//
//    func tagCollectionView(_ tagCollectionView: TTGTagCollectionView!, sizeForTagAt index: UInt) -> CGSize {
//        return tagView![Int(index)].frame.size
//    }
//
//    func numberOfTags(in tagCollectionView: TTGTagCollectionView!) -> UInt {
//        guard let model = self.model, let traits = model.traits, traits.count > 0 else {
//            return 0
//        }
//        return UInt(traits.count)
//    }
//
//    func tagCollectionView(_ tagCollectionView: TTGTagCollectionView!, tagViewFor index: UInt) -> UIView! {
//        return tagView![Int(index)]
//    }
//
//}

extension NFTDetailViewController {
    
    func viewForTratis(model: OpenSeaTrait) -> UIView {
        
        let type = model.trait_type?.split(separator: "_").compactMap { String($0).firstCapitalized }
            .joined(separator: "").camelCaseToWords().uppercased()
        
        let container = UIView()
        container.backgroundColor = .random
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.text = "\(type!): \(model.value!)"
        label.backgroundColor = AliceColor.lightBackground()
        label.sizeToFit()
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 4.0
        
        container.addSubview(label)
        container.sizeToFit()
//        container.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
    
}
