//
//  CoinListViewController.swift
//  AliceX
//
//  Created by lmcmz on 28/10/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import SPStorkController
import UIKit

class CoinListViewController: BaseViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!

    var isFromPopup: Bool = false

    var data: [CoinInfo] = []
    var filteredData: [CoinInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerCell(nibName: CoinListCell.nameOfClass)
        tableView.delegate = self
        searchBar.delegate = self

        //        let searchBarBackground: UIView? = searchBar.value(forKey: "background") as? UIView
        //        searchBarBackground?.removeFromSuperview()
        //        searchBar.backgroundColor = .clear
        searchBar.backgroundImage = UIImage()
        loadData()
    }

    func loadData() {
        let bundlePath = Bundle.main.path(forResource: "erc20", ofType: "json")
        let jsonString = try! String(contentsOfFile: bundlePath!)
        let coinInfoList = [CoinInfo].deserialize(from: jsonString) as! [CoinInfo]
        let coinList = coinInfoList.compactMap { $0 }
        let chainList = BlockChain.allCases.compactMap { Coin.coin(chain: $0).info! }
        let centerList = CoinInfoCenter.shared.pool.values.compactMap { $0 }

        var list = chainList
        list.mergeElements(newElements: coinList)
        list.mergeElements(newElements: centerList)

        data = list
        filteredData = data
        tableView.reloadData()
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

    @IBAction func addButtonClicked() {
        let vc = CustomTokenViewController()

        navigationController?.pushViewController(vc, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
        SPStorkController.scrollViewDidScroll(scrollView)
    }
}

extension CoinListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return filteredData.count
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CoinListCell.nameOfClass)
            as! CoinListCell
        let info = filteredData[indexPath.row]
        cell.configure(info: info)
        return cell
    }
}

extension CoinListViewController: UISearchBarDelegate {
    func searchBar(_: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? data : data.filter { (coin: CoinInfo) -> Bool in
            coin.name.range(of: searchText, options: .caseInsensitive) != nil ||
                coin.symbol.range(of: searchText, options: .caseInsensitive) != nil
        }

        tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_: UISearchBar) {
        view.endEditing(true)
    }
}
