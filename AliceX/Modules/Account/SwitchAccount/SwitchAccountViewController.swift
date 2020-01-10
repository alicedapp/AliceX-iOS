//
//  SwitchAccountViewController.swift
//  AliceX
//
//  Created by lmcmz on 5/1/20.
//  Copyright © 2020 lmcmz. All rights reserved.
//

import UIKit
import web3swift
import FoldingCell

class SwitchAccountViewController: BaseViewController {

    enum Const {
        static let closeCellHeight: CGFloat = 80 + 30
        static let openCellHeight: CGFloat = 260 + 30
    }
    
    enum Cells: Int, CaseIterable {
        case mnemonic = 0
        case account
        case create
        
        var cellName: String {
            switch self {
            case .mnemonic:
                return MnemonicTableViewCell.nameOfClass
            case .account:
                return SwitchAccountCell.nameOfClass
            case .create:
                return AddAccountCell.nameOfClass
            }
        }
        
//        var height: CGFloat {
//            switch self {
//            case .mnemonic:
//                return CGSize(width: , height: <#T##CGFloat#>)
//            case .account:
//                return SwitchAccountCell.nameOfClass
//            case .create:
//                return AddAccountCell.nameOfClass
//            }
//        }
    }
    
    var cellHeights: [CGFloat] = []
    
    @IBOutlet var tableView: UITableView!
    
    var data: [Account] = WalletManager.Accounts!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(nibName: SwitchAccountCell.nameOfClass)
        tableView.registerCell(nibName: AddAccountCell.nameOfClass)
        tableView.registerCell(nibName: MnemonicTableViewCell.nameOfClass)
//        tableView.registerHeaderFooter(nibName: AddAccountFooter.nameOfClass)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        
        
        cellHeights = Array(repeating: Const.closeCellHeight, count: data.count)
        NotificationCenter.default.addObserver(self, selector: #selector(swicthAccount), name: .accountChange, object: nil)
    }
    
    @objc func swicthAccount() {
        tableView.reloadData()
    }
}

extension SwitchAccountViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Cells.account.rawValue:
            return data.count
        case Cells.mnemonic.rawValue:
            return 2
        default:
            return 1
        }
    }
    
    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == Cells.account.rawValue {
//            return cellHeights[indexPath.row]
//        }
        
        switch indexPath.section {
        case Cells.account.rawValue:
            return cellHeights[indexPath.row]
        case Cells.mnemonic.rawValue:
            return 80
        case Cells.create.rawValue:
            return 100
        default:
            return 100
        }
    }
    
    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as SwitchAccountCell = cell else {
            return
        }

        cell.backgroundColor = .clear

        if cellHeights[indexPath.row] == Const.closeCellHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }

//        cell.number = indexPath.row
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case Cells.mnemonic.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: MnemonicTableViewCell.nameOfClass, for: indexPath) as! MnemonicTableViewCell
//            let account = data[indexPath.row]
            cell.configure(isMnemonic: indexPath.row == 0)
            return cell
        case Cells.account.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: SwitchAccountCell.nameOfClass, for: indexPath) as! SwitchAccountCell
            let account = data[indexPath.row]
            cell.configure(account: account)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: AddAccountCell.nameOfClass, for: indexPath) as! AddAccountCell
            cell.block = {
                self.data = WalletManager.Accounts!
                self.cellHeights.append(Const.closeCellHeight)
                tableView.reloadData()
            }
            return cell
        }

    }
    
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? FoldingCell else {
            return
        }

        if cell.isAnimating() {
            return
        }
        
        var duration = 0.0
        let cellIsCollapsed = cellHeights[indexPath.row] == Const.closeCellHeight
        if cellIsCollapsed {
            cellHeights[indexPath.row] = Const.openCellHeight
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellHeights[indexPath.row] = Const.closeCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.8
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
            
            // fix https://github.com/Ramotion/folding-cell/issues/169
            if cell.frame.maxY > self.tableView.frame.maxY {
                self.tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: true)
            }
        }, completion: nil)
    }
    
//    func tableView(_: UITableView, heightForFooterInSection _: Int) -> CGFloat {
//       return 100
//    }
//
//   func tableView(_ tableView: UITableView, viewForFooterInSection _: Int) -> UIView? {
//       var footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: AddAccountFooter.nameOfClass)
//       if footerView == nil {
//           footerView = AddAccountFooter.instanceFromNib()
//       }
//       return footerView
//   }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == Cells.create.rawValue {
            return nil
        }
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        headerView.backgroundColor = AliceColor.white()
        let label = UILabel()
        label.frame = CGRect.init(x: 20, y: 5, width: headerView.frame.width-40, height: headerView.frame.height-10)
        label.text = section == Cells.mnemonic.rawValue ? "Mnemonic" : "Accounts"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = AliceColor.darkGrey()
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == Cells.create.rawValue {
            return 0
        }
        
        return 50
    }
}
