//
//  NetworkSwitchViewController.swift
//  AliceX
//
//  Created by lmcmz on 4/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import SwiftEntryKit
import UIKit

class NetworkSwitchViewController: UIViewController {
    @IBOutlet var tableView: UITableView!

    var data: [String] = Web3NetEnum.allCases.map { "\($0)".firstUppercased }.filter { $0 != "Custom" }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(nibName: NetworkTableViewCell.nameOfClass)

        let index = data.firstIndex(of: Web3Net.currentNetwork.rawValue.firstUppercased) ?? 0
        let indexPath = IndexPath(row: index, section: 0)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: NetworkTableViewCell.nameOfClass)
            as! NetworkTableViewCell
        let netName = data[indexPath.row]
        cell.configure(network: netName)
        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let netName = data[indexPath.row].lowercased()
        Web3Net.upodateNetworkSelection(type: Web3NetEnum(rawValue: netName)!)
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
