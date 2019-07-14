//
//  DAppList.swift
//  AliceX
//
//  Created by lmcmz on 14/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit

class DAppListViewController: BaseViewController {
    
    weak var vcRef: BrowserViewController?
    
    @IBOutlet weak var tableView: UITableView!
    
    var dappList: [DAppModel]?
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(nibName: "DappTableViewCell")
        
        loadData()
    }
    
    func loadData() {
        let bundlePath = Bundle.main.path(forResource: "dapps", ofType: "json")
        let jsonString = try! String(contentsOfFile: bundlePath!)
        dappList = [DAppModel].deserialize(from: jsonString) as! [DAppModel]
        tableView.reloadData()
    }
}

extension DAppListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dappList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: DappTableViewCell.nameOfClass, for: indexPath) as! DappTableViewCell
        let model = dappList![indexPath.row]
        cell.configure(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dappList![indexPath.row]
        vcRef?.goTo(url: URL(string: model.link)!)
        HUDManager.shared.dismiss()
    }
}
