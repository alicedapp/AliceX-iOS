//
//  BaseViewController.swift
//  AliceX
//
//  Created by lmcmz on 7/6/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Hero
import UIKit

class BaseViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        PinManager.bringBallToFront()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hero.isEnabled = true
    }

    @IBAction func backButtonClicked() {
        guard navigationController != nil else {
            dismiss(animated: true, completion: nil)
            return
        }

        navigationController?.popViewController(animated: true)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if #available(iOS 12.0, *) {
            
            guard previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle else {
                return
            }
            
            let userInterfaceStyle = traitCollection.userInterfaceStyle
            themeDidChange(style: userInterfaceStyle)
            
            CallRNModule.isDarkMode(style: userInterfaceStyle)
        }
    }
    
    @available(iOS 12.0, *)
    func themeDidChange(style: UIUserInterfaceStyle) {
    }
}
