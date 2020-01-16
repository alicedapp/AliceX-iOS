//
//  WalletAvatarViewController.swift
//  AliceX
//
//  Created by lmcmz on 10/1/20.
//  Copyright © 2020 lmcmz. All rights reserved.
//

import UIKit
import ViewAnimator

class WalletAvatarViewController: BaseViewController {

    @IBOutlet var collectionView: UICollectionView!
    
    var data: [String] = Constant.animals
    
    var account: Account?
    
    class func make(account: Account) -> WalletAvatarViewController {
        let vc = WalletAvatarViewController()
        vc.account = account
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.registerCell(nibName: WalletImageCell.nameOfClass)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 34, right: 10)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        showAimation()
    }
    
    func showAimation() {
        collectionView.reloadSections(IndexSet(arrayLiteral: 0))

        let animateCell = collectionView!.visibleCells(in: 0)
        let orderCell = animateCell.sorted { (cell1, cell2) -> Bool in
            let index1 = self.collectionView.indexPath(for: cell1)!
            let index2 = self.collectionView.indexPath(for: cell2)!
            return index1.item < index2.item
        }

        let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
        cellAnimation(cells: orderCell, animator: animations)
    }

    func cellAnimation(cells: [UICollectionViewCell], animator: [AnimationType]) {
        collectionView.performBatchUpdates({
            UIView.animate(views: cells,
                           animations: animator,
                           duration: 0.1,
                           completion: nil)
        }, completion: nil)
    }
}

extension WalletAvatarViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WalletImageCell.nameOfClass,
                                                      for: indexPath) as! WalletImageCell
        let imageName = data[indexPath.row]
        cell.configure(name: imageName, account: account!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageName = data[indexPath.row]
        WalletManager.shared.updateAccount(account: account!, imageName: imageName, name: nil)
        account?.imageName = imageName
        collectionView.reloadData()
    }
}

extension WalletAvatarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (Constant.SCREEN_WIDTH - 20)/5 - 8
        return CGSize(width: width, height: width + 10)
    }
}
