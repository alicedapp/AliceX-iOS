//
//  BrowserSettingViewController.swift
//  AliceX
//
//  Created by lmcmz on 22/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Kingfisher
import SwiftyUserDefaults
import UIKit

class BrowserSettingViewController: UIViewController {
    weak var vcRef: BrowserViewController?

    @IBOutlet var googleTick: UILabel!
    @IBOutlet var duckduckgoTick: UILabel!

    @IBOutlet var googleLogo: UIImageView!
    @IBOutlet var duckduckgoLogo: UIImageView!

    @IBOutlet var homepageField: UITextField!
    @IBOutlet var homepageLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
//        homepageField.delegate = self

        configureLogo()

//        googleLogo.kf.setImage(with: FaviconHelper.bestIcon(domain: "googleLogo.com"))

        let homeURL = Defaults[\.homepage]
        homepageField.text = homeURL.absoluteString

        let engine = Defaults[\.searchEngine]
        switch engine {
        case SearchEngine.DuckDuckGo.rawValue:
            duckduckgoTick.isHidden = false
            googleTick.isHidden = true
        case SearchEngine.Google.rawValue:
            duckduckgoTick.isHidden = true
            googleTick.isHidden = false
        default:
            duckduckgoTick.isHidden = true
            googleTick.isHidden = true
        }
    }

    @IBAction func dismissView() {
        HUDManager.shared.dismiss()
//        dismiss(animated: true, completion: nil)
    }

    @IBAction func cacheButtonClicked() {
        let view = BaseAlertView.instanceFromNib(content: "Do you wanna clean browser cache?",
                                                 confirmBlock: {
                                                     BrowserViewController.cleanCache()
        }, cancelBlock: nil)

        HUDManager.shared.showAlertView(view: view, backgroundColor: .clear, haptic: .none,
                                        type: .centerFloat, widthIsFull: false, canDismiss: true)
    }

    @IBAction func googleClicked() {
        Defaults[\.searchEngine] = SearchEngine.Google.rawValue
        duckduckgoTick.isHidden = true
        googleTick.isHidden = false
    }

    @IBAction func duckduckgoClicked() {
        Defaults[\.searchEngine] = SearchEngine.DuckDuckGo.rawValue
        duckduckgoTick.isHidden = false
        googleTick.isHidden = true
    }

    @IBAction func setCurrentPageClicked() {
        guard let url = vcRef?.webview.url else {
            return
        }

        Defaults[\.homepage] = url
        homepageField.text = url.absoluteString
    }

    @IBAction func setButtonClicked() {
        guard let text = homepageField.text else {
            errorAlert(text: "Can't be empty")
            return
        }

        var urlString = text

        if !urlString.hasPrefix("http://"), !urlString.hasPrefix("https://") {
            urlString = urlString.addHttpPrefix()
        }

        guard let url = URL(string: urlString), urlString.validateUrl() else {
            errorAlert(text: "Not vaild url")
            return
        }

        successAlert(text: "Success")
        Defaults[\.homepage] = url
        homepageField.text = url.absoluteString
        view.endEditing(true)
    }

    func configureLogo() {
        if !ImageCache.default.isCached(forKey: "duckduckgo.com") {
            ImageDownloader.default.downloadImage(with: FaviconHelper.bestIcon(domain: "duckduckgo.com")) { result in
                switch result {
                case let .success(response):
                    self.duckduckgoLogo.image = response.image
                    self.duckduckgoLogo.backgroundColor = .clear
                    ImageCache.default.store(response.image, forKey: "duckduckgo.com")
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
        } else {
            ImageCache.default.retrieveImage(forKey: "duckduckgo.com") { result in
                onMainThread {
                    switch result {
                    case let .success(respone):
                        self.duckduckgoLogo.image = respone.image
                        self.duckduckgoLogo.backgroundColor = .clear
                    case let .failure(error):
                        print(error.localizedDescription)
                    }
                }
            }
        }

        if !ImageCache.default.isCached(forKey: "google.com") {
            ImageDownloader.default.downloadImage(with: FaviconHelper.bestIcon(domain: "google.com")) { result in
                switch result {
                case let .success(response):
                    self.googleLogo.image = response.image
                    self.googleLogo.backgroundColor = .clear
                    ImageCache.default.store(response.image, forKey: "google.com")
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
        } else {
            ImageCache.default.retrieveImage(forKey: "google.com") { result in
                onMainThread {
                    switch result {
                    case let .success(response):
                        self.googleLogo.image = response.image
                        self.googleLogo.backgroundColor = .clear
                    case let .failure(error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }

    func errorAlert(text: String) {
        errorAnimation()
        homepageLabel.text = text
        homepageLabel.textColor = Color.red
        delay(3) {
            self.errorAnimation()
            self.homepageLabel.text = "Current Homepage"
            self.homepageLabel.textColor = UIColor.lightGray
        }
    }

    func successAlert(text: String) {
        errorAnimation()
        homepageLabel.text = text
        homepageLabel.textColor = AliceColor.green
        delay(3) {
            self.errorAnimation()
            self.homepageLabel.text = "Current Homepage"
            self.homepageLabel.textColor = UIColor.lightGray
        }
    }

    func errorAnimation() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        transition.type = CATransitionType(rawValue: "cube")
        transition.subtype = CATransitionSubtype.fromBottom
        homepageLabel.layer.add(transition, forKey: "country1_animation")
    }
}

extension BrowserSettingViewController: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        guard let text = textField.text else {
//            return true
//        }
//
//        guard let url = URL(string: text) else {
//            //TODO
//            return false
//        }
//
//        return true
//    }
}
