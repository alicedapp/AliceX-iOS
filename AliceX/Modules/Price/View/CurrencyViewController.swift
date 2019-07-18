//
//  CurrencyViewController.swift
//  AliceX
//
//  Created by lmcmz on 19/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit

class CurrencyViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var data: [Currency] =  Currency.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(nibName: CurrencyTableViewCell.nameOfClass)
        
        let index = data.firstIndex(of: PriceHelper.shared.currentCurrency)
        let indexPath = IndexPath(row: index!, section: 0)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
    }
}


extension CurrencyViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyTableViewCell.nameOfClass)
            as! CurrencyTableViewCell
        let currency = self.data[indexPath.row]
        cell.configure(currency: currency)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currency = self.data[indexPath.row]
        PriceHelper.shared.changeCurrency(currency: currency)
    }
}
