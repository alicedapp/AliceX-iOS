//
//  CoinListViewController.swift
//  AliceX
//
//  Created by lmcmz on 28/10/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit

class CoinListViewController: BaseViewController {
    @IBOutlet var tableView: UITableView!
    var isFromPopup: Bool = false

    var data: [BlockChain] = BlockChain.allCases

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerCell(nibName: CoinListCell.nameOfClass)
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
        let chain = data[indexPath.row]
        cell.configure(chain: chain)
        return cell
    }
}
