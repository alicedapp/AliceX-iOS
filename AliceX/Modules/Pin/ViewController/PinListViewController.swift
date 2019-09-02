//
//  PinListViewController.swift
//  AliceX
//
//  Created by lmcmz on 1/9/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit

class PinListViewController: BaseViewController {
    var pinList: [Any]?
//    @IBOutlet var visualView: UIVisualEffectView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tableHeight: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.registerCell(nibName: PinListCell.nameOfClass)
        tableView.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi))
        tableView.estimatedRowHeight = 100
        tableView.sizeToFit()
    }

    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        tableHeight?.constant = tableView.contentSize.height
    }

    @IBAction func dismissVC() {
        view.alpha = 1
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
            self.view.alpha = 0
        }) { _ in
            self.dismiss(animated: false, completion: nil)
            self.view.alpha = 1
        }
    }

    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)
        view.alpha = 0
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
            self.view.alpha = 1
        }) { _ in
        }
    }
}

extension PinListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 3
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PinListCell.nameOfClass, for: indexPath) as! PinListCell
        cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        switch indexPath.item {
        case 0:
            cell.configure(image: UIImage.imageWithColor(color: UIColor.random), text: "AAAA", isTransaction: false)
        case 1:
            cell.configure(image: UIImage.imageWithColor(color: UIColor.random), text: "BBBB", isTransaction: true)
        case 2:
            cell.configure(image: UIImage.imageWithColor(color: UIColor.random), text: "CCCC", isTransaction: false)
        default:
            cell.configure(image: UIImage.imageWithColor(color: UIColor.random), text: "BBBB", isTransaction: true)
        }
        return cell
    }

    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt _: IndexPath) {
        viewWillLayoutSubviews()

//        cell.transform = CGAffineTransform(translationX: 0, y: 30)
//        cell.alpha = 0
//        UIView.animate(withDuration: 0.3) {
//            cell.alpha = 1
        ////            cell.transform = CGAffineTransform.identity
//            cell.transform = CGAffineTransform(translationX: 0, y: -30)
//        }
    }

    func tableView(_: UITableView, didEndDisplaying _: UITableViewCell, forRowAt _: IndexPath) {}
}
