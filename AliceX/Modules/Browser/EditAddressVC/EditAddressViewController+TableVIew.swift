//
//  EditAddressViewController+TableVIew.swift
//  AliceX
//
//  Created by lmcmz on 22/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation

extension EditAddressViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QuerySuggestCell.nameOfClass) as! QuerySuggestCell
        let result = data[indexPath.row]
        cell.configure(text: result)
        cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        var urlString = data[indexPath.row]
        urlString = EditAddressViewController.makeUrlIfNeeded(urlString: urlString)
        let url = URL(string: urlString)
        browerRef!.goTo(url: url!)
        backButtonClicked()
    }
}
