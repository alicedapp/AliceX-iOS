//
//  PinListViewController.swift
//  AliceX
//
//  Created by lmcmz on 1/9/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit
import ViewAnimator

class PinListViewController: BaseViewController {
    @IBOutlet var blurMask: UIVisualEffectView!

    let cellAnimations = [AnimationType.from(direction: .right, offset: 100.0)]

    var pinList: [PinItem] = PinManager.shared.pinList {
        didSet {
            if pinList.count == 0 {
                dismissVC()
            }
        }
    }

    var previousVC: UIViewController?

    @IBOutlet var tableView: UITableView!
    @IBOutlet var tableHeight: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.registerCell(nibName: PinListCell.nameOfClass)
//        tableView.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi))
//        tableView.estimatedRowHeight = 100
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tableTapped))
        self.tableView.backgroundView = UIView()
        self.tableView.backgroundView?.addGestureRecognizer(tap)
        
        cellAnimate()
    }
    
    @objc func tableTapped() {
        dismissVC()
    }

    func updateIfNeeded() {
        pinList = PinManager.shared.pinList
        tableView.reloadSections(IndexSet(integersIn: 0 ... 0), with: .fade)
    }

    func cellAnimate() {
        tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .none)
        let cells = tableView.visibleCells
        tableView.performBatchUpdates({
            UIView.animate(views: cells,
                           animations: cellAnimations,
                           completion: nil)
        }, completion: nil)
    }

    @IBAction func dismissVC() {
        onMainThread {
            let cells = self.tableView.visibleCells
            UIView.animate(views: cells,
                           animations: self.cellAnimations,
                           reversed: true,
                           initialAlpha: 1.0,
                           finalAlpha: 0.0,
                           completion: {
                               self.tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .none)
            })

            self.view.alpha = 1
            UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
                self.view.alpha = 0
            }) { _ in

                self.dismiss(animated: false) {
                    self.view.alpha = 1
                }
            }
        }
    }

    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)
        view.alpha = 0
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
            self.view.alpha = 1
        }) { _ in
        }
        cellAnimate()
    }

//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        view.alpha = 1
//        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
//            self.view.alpha = 0
//        }) { _ in
    ////            self.view.alpha = 1
//        }
//    }

    @available(iOS 12.0, *)
    override func themeDidChange(style: UIUserInterfaceStyle) {
        switch style {
        case .dark:
            blurMask.effect = UIBlurEffect(style: .dark)
        default:
            blurMask.effect = UIBlurEffect(style: .light)
        }
    }
}

extension PinListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return pinList.count
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PinListCell.nameOfClass, for: indexPath) as! PinListCell
//        cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        cell.previousVC = previousVC
        cell.parentVC = self

        let item = Array(pinList)[indexPath.row]
        cell.configure(item: item, index: indexPath)
        return cell
    }
}
