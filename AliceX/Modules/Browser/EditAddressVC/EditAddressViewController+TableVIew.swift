//
//  EditAddressViewController+TableVIew.swift
//  AliceX
//
//  Created by lmcmz on 22/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation

extension EditAddressViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QuerySuggestCell.nameOfClass) as! QuerySuggestCell
        let result = self.data[indexPath.row]
        cell.configure(text: result)
        cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var urlString = self.data[indexPath.row]
        urlString = EditAddressViewController.makeUrlIfNeeded(urlString: urlString)
        let url = URL(string: urlString)
        browerRef!.goTo(url: url!)
        backButtonClicked()
    }
}
