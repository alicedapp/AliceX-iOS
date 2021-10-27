//
//  DAppList.swift
//  AliceX
//
//  Created by lmcmz on 14/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Haneke
import PromiseKit
import UIKit

class DAppListViewController: BaseViewController {
    weak var vcRef: BrowserViewController?

    @IBOutlet var tableView: UITableView!

    var dappList: [DAppModel]?

    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(nibName: "DappTableViewCell")
        loadFromCache()
        requestData()
    }

    @IBAction func dismissView() {
        HUDManager.shared.dismiss()
    }

    func requestData() {
        GithubAPI.request(.dappList) { result in
            switch result {
            case let .success(response):
                guard let modelArray = try? JSONDecoder().decode([DAppModel].self,
                                                                 from: response.data) else {
                    return
                }

                self.dappList = modelArray
                self.tableView.reloadData()
                self.storeInCache()
            case let .failure(error):
                self.loadData()
                print(error.errorDescription)
            }
        }
    }

    func loadData() {
        let bundlePath = Bundle.main.url(forResource: "dapps", withExtension: "json")
        guard let jsonData = try? Data(contentsOf: bundlePath!),
              let model = try? JSONDecoder().decode([DAppModel].self, from: jsonData) else {
            return
        }
        dappList = model
        tableView.reloadData()
    }
}

extension DAppListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 90
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return dappList?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DappTableViewCell.nameOfClass, for: indexPath) as! DappTableViewCell
        let model = dappList![indexPath.row]
        cell.configure(model: model)
        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dappList![indexPath.row]
        if let vcRef = self.vcRef {
            vcRef.goTo(url: URL(string: model.link)!)
            HUDManager.shared.dismiss()
        } else {
            let vc = BrowserWrapperViewController.make(urlString: model.link)
            UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
            HUDManager.shared.dismiss()
        }
    }
}

extension DAppListViewController {
    func loadFromCache() {
        let cacheKey = CacheKey.browserDappList
        Shared.dataCache.fetch(key: cacheKey).onSuccess { result in
            guard let modelArray = try? JSONDecoder().decode([DAppModel].self,
                                                             from: result) else {
                return
            }

            self.dappList = modelArray as! [DAppModel]
            self.tableView.reloadData()
        }.onFailure { _ in
            self.loadData()
        }
    }

    func storeInCache() {
        guard let data = try? JSONEncoder().encode(dappList) else {
            return
        }
        let cacheKey = CacheKey.browserDappList
        Shared.dataCache.set(value: data, key: cacheKey)
    }
}
