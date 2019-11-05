//
//  CoinListViewController.swift
//  AliceX
//
//  Created by lmcmz on 28/10/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit
import SPStorkController

class CoinListViewController: BaseViewController {
    @IBOutlet var tableView: UITableView!
    var isFromPopup: Bool = false

    var data: [Coin] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerCell(nibName: CoinListCell.nameOfClass)
        tableView.delegate = self
    }

    @IBAction func closeButtonClicked() {
        if !isFromPopup {
            backButtonClicked()
            return
        }

        guard let navi = self.navigationController else {
            dismiss(animated: true, completion: nil)
            return
        }
        navi.dismiss(animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        SPStorkController.scrollViewDidScroll(scrollView)
    }
}

extension CoinListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return data.count
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CoinListCell.nameOfClass)
            as! CoinListCell
        let coin = data[indexPath.row]
        cell.configure(coin: coin)
        return cell
    }
}
