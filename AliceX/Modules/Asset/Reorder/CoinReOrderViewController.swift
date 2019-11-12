//
//  CoinReOrderViewController.swift
//  AliceX
//
//  Created by lmcmz on 7/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit

class CoinReOrderViewController: BaseViewController {

    @IBOutlet var pinCollectionView: KDDragAndDropCollectionView!
    @IBOutlet var watchCollectionView: KDDragAndDropCollectionView!
    @IBOutlet var ignoreCollectionView: KDDragAndDropCollectionView!
    
    var data: [[Coin]] = [[Coin]]()
    var dragAndDropManager: KDDragAndDropManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pinCollectionView.registerCell(nibName: CoinReOrderCell.nameOfClass)
        watchCollectionView.registerCell(nibName: CoinReOrderCell.nameOfClass)
        ignoreCollectionView.registerCell(nibName: CoinReOrderCell.nameOfClass)
        
        let watchList = WatchingCoinHelper.shared.list
//        let pinedList = Array(CoinInfoHelper.shared.pool.values).filter {($0.isPined ?? false)}.map { info -> Coin in
//            return info.coin
//        }
//        let unPinedList = watchList.filter { !($0.info!.isPined ?? false) }
        
        var pinList: [Coin] = []
        var unPinedList: [Coin] = []
        
        for coin in watchList {
            
            if let info = coin.info, info.isPined == true {
                pinList.append(coin)
            } else {
                unPinedList.append(coin)
            }
        }
        
        self.data = [pinList, unPinedList, IgnoreCoinHelper.shared.list]
        
        self.dragAndDropManager = KDDragAndDropManager(
            canvas: self.view,
            collectionViews: [pinCollectionView, watchCollectionView, ignoreCollectionView]
        )
    }
    
    @IBAction func closeButtonClick() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateList()
    }
    
    // TODO: Replace stupid CoinInfo
    func updateList() {
        let pinList = data[0]
        let watchingList = data[1]
        let ignoreList = data[2]
        
        pinList.forEach { coin in
            CoinInfoHelper.shared.pin(coin: coin)
        }
        
        watchingList.forEach { coin in
            CoinInfoHelper.shared.unpin(coin: coin)
        }
        
        IgnoreCoinHelper.shared.updateList(newList: ignoreList)
        
        let newCoinList =  pinList + watchingList
        WatchingCoinHelper.shared.updateList(newList: newCoinList)
        CoinInfoHelper.shared.storeInCache()
    }
}

extension CoinReOrderViewController: KDDragAndDropCollectionViewDataSource {
    
    //MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data[collectionView.tag].count
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoinReOrderCell.nameOfClass,
                                                      for: indexPath) as! CoinReOrderCell
        
        let dataItem = data[collectionView.tag][indexPath.item]
        
        cell.configure(coin: dataItem)
        cell.isHidden = false
        
        if let kdCollectionView = collectionView as? KDDragAndDropCollectionView {
            
            if let draggingPathOfCellBeingDragged = kdCollectionView.draggingPathOfCellBeingDragged {
                
                if draggingPathOfCellBeingDragged.item == indexPath.item {
                    
                    cell.isHidden = true
                    
                }
            }
        }
        
        return cell
    }

    // MARK: KDDragAndDropCollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, dataItemForIndexPath indexPath: IndexPath) -> AnyObject {
        return data[collectionView.tag][indexPath.item] as! AnyObject
    }
    
    func collectionView(_ collectionView: UICollectionView, insertDataItem dataItem : AnyObject, atIndexPath indexPath: IndexPath) -> Void {
        
        if let coin = dataItem as? Coin {
            
//            let tag = collectionView.tag
//            switch tag {
//            case 0:
//                CoinInfoHelper.shared.pin(coin: coin)
//            case 1:
//                WatchingCoinHelper.shared.add(coin: coin, updateCache: true)
//            case 2:
//                IgnoreCoinHelper.shared.add(coin: coin)
//            default:
//                break
//            }
            
            data[collectionView.tag].insert(coin, at: indexPath.item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, deleteDataItemAtIndexPath indexPath : IndexPath) -> Void {
        
//        let tag = collectionView.tag
//        let coin = data[collectionView.tag][indexPath.item]
//
//        switch tag {
//        case 0:
//            CoinInfoHelper.shared.unpin(coin: coin)
//        case 1:
//
//            if coin.info!.isPined {
//                WatchingCoinHelper.shared.remove(coin: coin, updateCache: true)
//            } else {
//
//            }
//
//        case 2:
//            IgnoreCoinHelper.shared.remove(coin: coin)
//        default:
//            break
//        }
        
        data[collectionView.tag].remove(at: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, moveDataItemFromIndexPath from: IndexPath, toIndexPath to : IndexPath) -> Void {
        let fromDataItem: Coin = data[collectionView.tag][from.item]
        data[collectionView.tag].remove(at: from.item)
        data[collectionView.tag].insert(fromDataItem, at: to.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, indexPathForDataItem dataItem: AnyObject) -> IndexPath? {
        
        guard let candidate = dataItem as? Coin else { return nil }
        
        for (i,item) in data[collectionView.tag].enumerated() {
            if candidate != item { continue }
            return IndexPath(item: i, section: 0)
        }
        return nil
    }
}

extension CoinReOrderViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let len = ((Constant.SCREEN_WIDTH - 3*10) / 3) - 5
        return CGSize(width: len, height: 50)
    }
    
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
           return 1
       }

       func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
           return 1
       }
    
}
