//
//  EditAddressViewController.swift
//  AliceX
//
//  Created by lmcmz on 12/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import SwiftyUserDefaults
import UIKit

class EditAddressViewController: BaseViewController {
    @IBOutlet var addressField: UITextField!
    @IBOutlet var tableView: UITableView!

    var data: [String] = []

    weak var browerRef: BrowserViewController?
    var address: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        addressField.text = address
        addressField.delegate = self

        tableView.delegate = self
        tableView.dataSource = self
        tableView.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi))
        tableView.registerCell(nibName: QuerySuggestCell.nameOfClass)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addressField.becomeFirstResponder()
    }

    //    @IBAction func closeButtonClicked(){
    //        view.endEditing(true)
    //        self.hero.dismissViewController()
    //    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //        view.becomeFirstResponder()
        view.endEditing(true)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 {
                view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification _: NSNotification) {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }

    class func makeUrlIfNeeded(urlString: String) -> String {
        var urlString = urlString

        if !urlString.hasPrefix("http://"), !urlString.hasPrefix("https://") {
            urlString = urlString.addHttpPrefix()
        }

        if urlString.validateUrl() {
            return urlString
        }

        if urlString.hasPrefix("http://") {
            urlString = String(urlString.dropFirst(7))
        }

        if urlString.hasPrefix("https://") {
            urlString = String(urlString.dropFirst(8))
        }

        let defaultEngine = Defaults[\.searchEngine]
        let engine = SearchEngine(rawValue: defaultEngine)!

        urlString = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        urlString = "\(engine.queryString)\(urlString)"

        return urlString
    }
}

extension EditAddressViewController: UITextFieldDelegate {
    @IBAction func textFieldChange() {
        guard let text = addressField.text else {
            return
        }

        if text.hasPrefix("http://") || text.hasPrefix("https://") {
            return
        }

        // TODO:
        /// Cancel the previous one
        QuerySuggestAPI.request(.query(text: text)) { result in
            switch result {
            case let .success(response):
                guard let modelArray = response.mapArray(QuerySuggestModel.self) else {
                    return
                }
                let suggests = modelArray.compactMap { $0?.phrase }
                self.data = suggests
                self.tableView.reloadData()
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }

    func textFieldShouldReturn(_: UITextField) -> Bool {
        guard let urlString = addressField.text,
              let browerRef = browerRef else {
            return false
        }
        let newUrlString = EditAddressViewController.makeUrlIfNeeded(urlString: urlString)
        let url = URL(string: newUrlString)
        browerRef.goTo(url: url!)
        backButtonClicked()
        return true
    }
}
