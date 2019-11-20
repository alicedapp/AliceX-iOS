//
//  MiniAppCollectionViewCell.swift
//  AliceX
//
//  Created by lmcmz on 20/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Kingfisher
import UIKit

class MiniAppCollectionViewCell: UICollectionViewCell {
    @IBOutlet var shadowView: UIView!
    @IBOutlet var iconView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emojiLabel: UILabel!

    @IBOutlet var colorView: UIView!
    
    var url: URL?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(imageCached(noti:)), name: .faviconDownload, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func imageCached(noti: Notification) {
        
        guard let info = noti.userInfo, let domain = info["domain"] as? String else {
            return
        }
        
        guard let url = self.url, let localDomain = url.host, localDomain == domain else {
            return
        }
           
       ImageCache.default.retrieveImage(forKey: domain) { result in
        onMainThread {
           switch result {
           case let .success(respone):
                if let image = respone.image {
                   self.iconView.image = image
                    self.emojiLabel.isHidden = true
                   return
               }
               self.emojiLabel.isHidden = false
               self.emojiLabel.text = Constant.randomEmoji()
           case .failure:
               self.emojiLabel.isHidden = false
               self.emojiLabel.text = Constant.randomEmoji()
           }
        }
       }
    }

//    override func layoutSubviews() {
//        iconView.layer.cornerRadius = iconView.bounds.height/2
//    }

    func setup() {
        layoutIfNeeded()
        iconView.layer.cornerRadius = iconView.bounds.height / 2
        shadowView.layer.cornerRadius = shadowView.bounds.height / 2

        colorView.layer.cornerRadius = colorView.bounds.height / 2
        
        shadowView.layer.shadowColor = UIColor(hex: "#000000", alpha: 0.5).cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        shadowView.layer.shadowOpacity = 0.3
        shadowView.layer.shadowRadius = 5
    }

    func configure(item: HomeItem) {
        setup()

        self.emojiLabel.isHidden = true
        nameLabel.text = item.name.firstCapitalized

        if item.isApp {
            if item.name == "CheezeWizards" {
                colorView.backgroundColor = .yellow
            } else {
                colorView.backgroundColor = .clear
            }
            
            let url = URL(string: "https://github.com/alicedapp/AliceX/blob/master/src/Apps/\(item.name)/Assets/logo.png?raw=true")!
            iconView.kf.setImage(with: url) { result in
                switch result {
                case .success:
                    break
                case .failure:
                    self.emojiLabel.isHidden = false
                    self.emojiLabel.text = Constant.randomEmoji()
                }
            }
        } else {
            
            guard let url = item.url, let domain = url.host else {
                self.emojiLabel.isHidden = false
                self.emojiLabel.text = Constant.randomEmoji()
                return
            }
            
            self.url = url
            
            ImageCache.default.retrieveImage(forKey: domain) { result in
                onMainThread {
                    switch result {
                    case let .success(respone):
                        if let image = respone.image {
                            self.iconView.image = image
                            return
                        }
                        self.emojiLabel.isHidden = false
                        self.emojiLabel.text = Constant.randomEmoji()
                    case let .failure:
                        self.emojiLabel.isHidden = false
                        self.emojiLabel.text = Constant.randomEmoji()
                    }
                }
            }
        }
    }
}
