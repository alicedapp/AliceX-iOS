//
//  NetworkSwitchViewController.swift
//  AliceX
//
//  Created by lmcmz on 4/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import SwiftEntryKit
import UIKit
import SPStorkController

class NetworkSwitchViewController: UIViewController {
    @IBOutlet var tableView: UITableView!

    var data: [Web3NetEnum] = Web3NetEnum.allCases

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(nibName: NetworkTableViewCell.nameOfClass)
        tableView.registerCell(nibName: CustomNetworkCell.nameOfClass)
        
        tableView.registerHeaderFooter(nibName: RPCCustomFooterView.nameOfClass)

        let index = data.firstIndex(of: WalletManager.currentNetwork) ?? 0
        let indexPath = IndexPath(row: index, section: 0)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
        
        NotificationCenter.default.addObserver(self, selector: #selector(addRPC), name: .customRPCChange, object: nil)
    }
    
    @objc func addRPC() {
        data = Web3NetEnum.allCases
        tableView.reloadData()
        let index = data.firstIndex(of: WalletManager.currentNetwork) ?? 0
        let indexPath = IndexPath(row: index, section: 0)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        SPStorkController.scrollViewDidScroll(scrollView)
    }
}

extension NetworkSwitchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return data.count
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let net = data[indexPath.row]
        
        if net.isCustom {
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomNetworkCell.nameOfClass) as! CustomNetworkCell
            let netName = data[indexPath.row]
            cell.configure(network: netName)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NetworkTableViewCell.nameOfClass)
            as! NetworkTableViewCell
        let netName = data[indexPath.row]
        cell.configure(network: netName)
        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let network = data[indexPath.row]
        WalletManager.updateNetworkSelection(type: network)
    }
    
    func tableView(_: UITableView, heightForFooterInSection _: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection _: Int) -> UIView? {
        var footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: RPCCustomFooterView.nameOfClass)
        if footerView == nil {
            footerView = RPCCustomFooterView.instanceFromNib()
        }
        return footerView
    }

//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let netName = self.data[indexPath.row]
//        if netName.lowercased() == Web3Net.currentNetwork.rawValue {
//            cell.setSelected(true, animated: true)
//            return
//        }
//
//        cell.setSelected(false, animated: false)
//    }
}
