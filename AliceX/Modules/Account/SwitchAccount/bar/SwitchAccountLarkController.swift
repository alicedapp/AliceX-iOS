//
//  SwitchAccountLarkController.swift
//  AliceX
//
//  Created by lmcmz on 8/1/20.
//  Copyright © 2020 lmcmz. All rights reserved.
//

import UIKit

class SwitchAccountLarkController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!

    var data: [Account] = WalletManager.Accounts!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerCell(nibName: SwitchAccountLarkCell.nameOfClass)
        
        NotificationCenter.default.addObserver(self, selector: #selector(swicthAccount), name: .accountChange, object: nil)
    }
    
    @objc func swicthAccount() {
        collectionView.reloadData()
        delay(0.5) {
            self.dismiss(animated: true, completion: nil)
        }
    }
}


extension SwitchAccountLarkController: UICollectionViewDelegate, UICollectionViewDataSource {
//    func numberOfSections(in _: UICollectionView) -> Int {
//        return Asset.allCases.count
//    }

    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SwitchAccountLarkCell.nameOfClass,
                                                      for: indexPath) as! SwitchAccountLarkCell
        let account = data[indexPath.row]
        cell.configure(account: account)
        return cell
    }
}


extension SwitchAccountLarkController: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 80)
    }
}
