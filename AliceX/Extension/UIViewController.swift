//
//  UIViewController.swift
//  AliceX
//
//  Created by lmcmz on 30/10/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import JXSegmentedView
//
extension UIViewController: JXSegmentedListContainerViewListDelegate {
    public func listView() -> UIView {
        return view
    }

    func addChildVCToView(childController: UIViewController, onView: UIView?) {
        var holderView = view
        if let onView = onView {
            holderView = onView
        }
        addChild(childController)
        holderView!.addSubview(childController.view)
        //        constrainViewEqual(hfuolderView, view: childController.view)
        childController.view.fillSuperview()
        childController.didMove(toParent: self)
        childController.willMove(toParent: self)
    }

    /// Adds child view controller to the parent.
    ///
    /// - Parameter child: Child view controller.
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }

    /// It removes the child view controller from the parent.
    func remove() {
        guard parent != nil else {
            return
        }
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }

    static func loadFromNib() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            return T(nibName: String(describing: T.self), bundle: nil)
        }

        return instantiateFromNib()
    }
}
