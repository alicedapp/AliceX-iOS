//
//  MnemonicsViewController.swift
//  AliceX
//
//  Created by lmcmz on 2/10/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit

class MnemonicsViewController: BaseViewController {
    var isShown: Bool = false
    @IBOutlet var collectionContainer: UIView!
    @IBOutlet var showLabel: UILabel!

    var collectionView: TTGTextTagCollectionView!
    let secertText = ["🎩👱🏻‍♀️🐇🕳", "✨😺", "🤡☕", "🍰🧁💨🐛", "🐇🕒🏰", "♠️♣️❤️👸",
                      "🎩👱🏻‍♀️🐇🕳", "✨😺", "🤡☕", "🍰🧁💨🐛", "🐇🕒🏰", "♠️♣️❤️👸"]

    let tags = KeychainHepler.shared.fetchKeychain(key: Setting.MnemonicsKey)?.components(separatedBy: .whitespaces)

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView = TTGTextTagCollectionView()
        collectionView.delegate = self
        collectionView.enableTagSelection = false
        collectionView.alignment = .fillByExpandingWidthExceptLastLine
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionContainer.addSubview(collectionView)
        collectionView.fillSuperview()
        collectionView.addTags(secertText)

        let configure = collectionView.defaultConfig
        configure?.backgroundColor = AliceColor.lightGrey
        configure?.textColor = .white
        configure?.borderColor = .clear
        configure?.cornerRadius = 20
        configure?.shadowColor = .clear
        configure?.maxWidth = 100
        configure?.textFont = UIFont.systemFont(ofSize: 20, weight: .regular)
    }

    @IBAction func showButtonClick() {
        isShown = !isShown
        let impactLight = UIImpactFeedbackGenerator(style: .light)
        impactLight.impactOccurred()

        if isShown {
            let configure = collectionView.defaultConfig
            configure?.backgroundColor = AliceColor.dark
            showLabel.text = "🙈  Hide"
            collectionView.removeAllTags()
            collectionView.addTags(tags)
            return
        }
        let configure = collectionView.defaultConfig
        configure?.backgroundColor = AliceColor.lightGrey
        showLabel.text = "🐵  Show"
        collectionView.removeAllTags()
        collectionView.addTags(secertText)
    }

    @IBAction func backupButtonClick() {
        let configure = collectionView.defaultConfig
        configure?.backgroundColor = AliceColor.lightGrey
        showLabel.text = "🐵  Show"
        collectionView.removeAllTags()
        collectionView.addTags(secertText)

        let vc = BackupViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

//        if #available(iOS 12.0, *) {
//            let userInterfaceStyle = traitCollection.userInterfaceStyle
//            switch userInterfaceStyle {
//            case .dark:
//
//            default:
//                <#code#>
//            }
//        }
    }
}

extension MnemonicsViewController: TTGTextTagCollectionViewDelegate {}
