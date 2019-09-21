//
//  PinListViewController.swift
//  AliceX
//
//  Created by lmcmz on 1/9/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit

class PinListViewController: BaseViewController {
    
    var pinList: Array<PinItem> = PinManager.shared.pinList {
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
        tableView.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi))
        tableView.estimatedRowHeight = 100
        tableView.sizeToFit()
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        tableHeight?.constant = tableView.contentSize.height
    }
    
    func updateIfNeeded() {
        pinList = PinManager.shared.pinList
        tableView.reloadSections(IndexSet(integersIn: 0...0), with: .automatic)
    }

    @IBAction func dismissVC() {
        view.alpha = 1
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
            self.view.alpha = 0
        }) { _ in
            self.dismiss(animated: false, completion: nil)
            self.view.alpha = 1
//            PinManager.shared.show()
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
        return pinList.count
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PinListCell.nameOfClass, for: indexPath) as! PinListCell
        cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        cell.previousVC = previousVC
        cell.parentVC = self
        
        let item = Array(pinList)[indexPath.row]
        cell.configure(item: item, index: indexPath)
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

// extension PinListViewController: UINavigationControllerDelegate {
//    func navigationController(_: UINavigationController,
//                              animationControllerFor operation: UINavigationController.Operation,
//                              from _: UIViewController,
//                              to _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        switch operation {
//        case .push:
//            return PinTransitionPush()
////        case .pop:
////            return FadePopAnimator()
//        default:
//            return nil
//        }
//    }
// }
