//
//  MiniAppSearchVC.swift
//  AliceX
//
//  Created by lmcmz on 4/3/20.
//  Copyright © 2020 lmcmz. All rights reserved.
//

import Haneke
import SPStorkController
import SwiftyUserDefaults
import UIKit

class MiniAppSearchVC: BaseViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!

    var isFromPopup: Bool = false

    var data: [DAppModel] = []
    var filteredData: [DAppModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerCell(nibName: DappTableViewCell.nameOfClass)
        tableView.registerCell(nibName: AppToBrowserCell.nameOfClass)
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self

        //        let searchBarBackground: UIView? = searchBar.value(forKey: "background") as? UIView
        //        searchBarBackground?.removeFromSuperview()
        //        searchBar.backgroundColor = .clear
        searchBar.backgroundImage = UIImage()
        loadFromCache()
        requestData()
    }

    func requestData() {
        GithubAPI.request(.dappList) { result in
            switch result {
            case let .success(response):
                guard let modelArray = try? JSONDecoder().decode([DAppModel].self,
                                                                 from: response.data) else {
                    return
                }

                self.data = modelArray as! [DAppModel]
                self.filteredData = self.data
                self.tableView.reloadData()
                self.storeInCache()
            case let .failure(error):
                //                self.loadFromCache()
                print(error.errorDescription)
            }
        }
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
        view.endEditing(true)
        SPStorkController.scrollViewDidScroll(scrollView)
    }
}

extension MiniAppSearchVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in _: UITableView) -> Int {
        return data.count == filteredData.count ? 1 : 2
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return filteredData.count
        case 1:
            return 1
        default:
            return 0
        }
    }

    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 90
        case 1:
            return 75
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: DappTableViewCell.nameOfClass)
                as! DappTableViewCell
            let model = filteredData[indexPath.row]
            cell.configure(model: model)
            return cell
        }

        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: AppToBrowserCell.nameOfClass)
                as! AppToBrowserCell
            return cell
        }

        return UITableViewCell()
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            switch indexPath.section {
            case 0:
                let model = self.filteredData[indexPath.row]
                let vc = BrowserWrapperViewController.make(urlString: model.link)
                UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
            case 1:
                let defaultEngine = Defaults[\.searchEngine]
                let engine = SearchEngine(rawValue: defaultEngine)!
                let link = "\(engine.queryString)\(self.searchBar.text ?? "")"
                let vc = BrowserWrapperViewController.make(urlString: link)
                UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
        }
    }
}

extension MiniAppSearchVC: UISearchBarDelegate {
    func searchBar(_: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? data : data.filter { (dapp: DAppModel) -> Bool in
            dapp.name.range(of: searchText, options: .caseInsensitive) != nil ||
                dapp.category?.range(of: searchText, options: .caseInsensitive) != nil
        }

        tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_: UISearchBar) {
        view.endEditing(true)
    }
}

extension MiniAppSearchVC {
    func loadFromCache() {
        let cacheKey = CacheKey.browserDappList
        Shared.dataCache.fetch(key: cacheKey).onSuccess { result in
            guard let modelArray = try? JSONDecoder().decode([DAppModel].self,
                                                             from: result) else {
                return
            }
            self.data = modelArray
            self.filteredData = self.data
            self.tableView.reloadData()
        }.onFailure { error in
            print(error?.localizedDescription)
        }
    }

    func storeInCache() {
        guard let data = try? JSONEncoder().encode(data) else {
            return
        }
        let cacheKey = CacheKey.browserDappList
        Shared.dataCache.set(value: data, key: cacheKey)
    }
}
