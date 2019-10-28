//
//  CurrencyViewController.swift
//  AliceX
//
//  Created by lmcmz on 19/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit
import SPStorkController

class CurrencyViewController: BaseViewController {
    @IBOutlet var tableView: UITableView!

    var data: [Currency] = Currency.allCases
    var isFromPopup: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(nibName: CurrencyTableViewCell.nameOfClass)

        let index = data.firstIndex(of: PriceHelper.shared.currentCurrency)
        let indexPath = IndexPath(row: index!, section: 0)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        SPStorkController.scrollViewDidScroll(scrollView)
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

extension CurrencyViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return data.count
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyTableViewCell.nameOfClass)
            as! CurrencyTableViewCell
        let currency = data[indexPath.row]
        cell.configure(currency: currency)
        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currency = data[indexPath.row]
        PriceHelper.shared.changeCurrency(currency: currency)
    }
}
