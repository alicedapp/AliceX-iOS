//
//  AssetTXViewController.swift
//  AliceX
//
//  Created by lmcmz on 6/2/20.
//  Copyright © 2020 lmcmz. All rights reserved.
//

import ESPullToRefresh
import PromiseKit
import UIKit

class AssetTXViewController: UIViewController {
    var tableView: UITableView!
    var listViewDidScrollCallback: ((UIScrollView) -> Void)?

    var data: [AmberdataTXModel] = []
    var page: Int = 0
    
    override init(nibName: String?, bundle: Bundle?) {
       super.init(nibName: nibName, bundle: bundle)
        
        tableView = UITableView(frame: view.frame, style: .plain)
        tableView.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        tableView.fillSuperview()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(nibName: AssetTXCell.nameOfClass)

        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 104, right: 0)
        
        tableView.es.addInfiniteScrolling {
            self.page += 1
            self.requestData(page: self.page)
        }
        
        requestData(page: 0)
   }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func requestData(page: Int) {
        let address = WalletManager.currentAccount!.address
//            WalletCore.address(blockchain: .Ethereum)
        
        firstly { () -> Promise<[AmberdataTXModel?]> in
            API(AmberData.addressTX(address: address, page: page), path: "payload.records")
        }.done { list in
//            print("AAAAAA")
//            print(list)
            self.data = list.compactMap { $0 }.sorted(by: { (model1, model2) -> Bool in
                guard let date1 = model1.timestamp, let date2 = model2.timestamp else {
                    return true
                }
                return date1 > date2
            })
            self.tableView.reloadData()
        }.ensure {
            self.tableView.es.stopLoadingMore()
        }.catch { error in
//            print("BBBB")
            print(error.localizedDescription)
        }
    }
}

extension AssetTXViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return data.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AssetTXCell.nameOfClass, for: indexPath) as! AssetTXCell
        let tx = data[indexPath.row]
        cell.configure(model: tx)
        return cell
    }

    public func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tx = data[indexPath.row]
        let vc = BrowserWrapperViewController.make(urlString: "https://etherscan.io/tx/\(tx.hash!)")
        UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        listViewDidScrollCallback?(scrollView)
    }
}

extension AssetTXViewController: JXPagingViewListViewDelegate {
    public override func listView() -> UIView {
        return view
    }

    public func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> Void) {
        listViewDidScrollCallback = callback
    }

    public func listScrollView() -> UIScrollView {
        return tableView
    }
}
