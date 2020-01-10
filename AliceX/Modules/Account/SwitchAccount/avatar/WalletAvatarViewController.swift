//
//  WalletAvatarViewController.swift
//  AliceX
//
//  Created by lmcmz on 10/1/20.
//  Copyright © 2020 lmcmz. All rights reserved.
//

import UIKit

class WalletAvatarViewController: BaseViewController {

    @IBOutlet var collectionView: UICollectionView!
    
    var data: [String] = ["baboon","cow","frog","llama","sheep","bear","crab","giraffe","mink","skunk","beaver","crocodile","globefish","moose","sloth","bison","deadlock","goat","mouse","snake","boar","deer","goldfish","owl","sparrow","bulldog","dog","guinea", "pig","panda", "kangaroo","squirrel","butterfly","dolphin","hedgehog","pig","starfish","capybara","duck","hippopotamus","platypus","swan","cat","eagle","horse","rabbit","tiger","chameleon","elephant","koala","raccoon","wolf","chimpanzee","fennec","lemur","seal","colibri","fox","lion","shark"]
    
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
