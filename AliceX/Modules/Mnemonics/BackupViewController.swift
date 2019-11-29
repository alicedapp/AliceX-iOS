//
//  BackupViewController.swift
//  AliceX
//
//  Created by lmcmz on 2/10/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import SwiftyUserDefaults
import UIKit

class BackupViewController: BaseViewController {
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var selectContainer: UIView!
    @IBOutlet var displayContainer: UIView!

    @IBOutlet var nextButton: UIControl!
    @IBOutlet var nextLabel: UILabel!

    var selectCollection: TTGTextTagCollectionView!
    var displayCollection: TTGTextTagCollectionView!

    let mnemonic = KeychainHepler.shared.fetchKeychain(key: Setting.MnemonicsKey)?.components(separatedBy: .whitespaces)

    var shuffled: [String]!
    var isInCorrect: Bool = false {
        didSet {
            errorLabel.isHidden = !isInCorrect
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        shuffled = mnemonic!.shuffled()

        selectCollection = TTGTextTagCollectionView()
        selectCollection.delegate = self
        selectCollection.alignment = .fillByExpandingWidthExceptLastLine
        selectCollection.translatesAutoresizingMaskIntoConstraints = false
        selectContainer.addSubview(selectCollection)
        selectCollection.fillSuperview()
        selectCollection.addTags(shuffled)

        let configure = selectCollection.defaultConfig
        configure?.backgroundColor = AliceColor.dark
        configure?.textColor = .white
        configure?.borderColor = .clear
        configure?.cornerRadius = 20
        configure?.shadowColor = .clear
        configure?.maxWidth = 100

        configure?.selectedTextColor = .clear
        configure?.selectedBorderColor = .clear
        configure?.selectedBackgroundColor = AliceColor.lightGrey
        configure?.selectedCornerRadius = 20
        configure?.shadowColor = .clear
        configure?.textFont = UIFont.systemFont(ofSize: 20, weight: .regular)

        displayCollection = TTGTextTagCollectionView()
        displayCollection.delegate = self
        displayContainer.addSubview(displayCollection)
        displayCollection.fillSuperview()
//        displayCollection.addTags(displayTag)

        let displayConfig = displayCollection.defaultConfig

        displayConfig?.backgroundColor = AliceColor.dark
        displayConfig?.textColor = .white
        displayConfig?.borderColor = .clear
        displayConfig?.cornerRadius = 20
        displayConfig?.shadowColor = .clear
        displayConfig?.textFont = UIFont.systemFont(ofSize: 20, weight: .regular)

        setNextButtonHighlight()
    }

    func setNextButtonHighlight() {
        // Mnemonic long == 12
        if displayCollection.allTags().count != 12 || isInCorrect {
            nextButton.isUserInteractionEnabled = false
            nextLabel.textColor = AliceColor.lightDark
            nextButton.backgroundColor = AliceColor.lightGrey
            return
        }
        nextButton.isUserInteractionEnabled = true
        nextLabel.textColor = .white
        nextButton.backgroundColor = AliceColor.dark
    }

    func checkError() {
        guard let words = displayCollection.allTags() else {
            return
        }

        if words.count == 0 {
            isInCorrect = false
            return
        }

        for (index, tag) in words.enumerated() {
            if tag != mnemonic![index] {
                isInCorrect = true
                return
            }
        }
        isInCorrect = false
    }

    @IBAction func completeButtonClick() {
        let impactLight = UIImpactFeedbackGenerator(style: .light)
        impactLight.impactOccurred()

        Defaults[\.MnemonicsBackup] = true
        navigationController?.popToRootViewController(animated: true)
        
        NotificationCenter.default.post(name: .mnemonicBackuped, object: nil)
    }
}

extension BackupViewController: TTGTextTagCollectionViewDelegate {
    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, didTapTag tagText: String!, at index: UInt, selected: Bool, tagConfig _: TTGTextTagConfig!) {
        let impactLight = UIImpactFeedbackGenerator(style: .light)
        impactLight.impactOccurred()

        if textTagCollectionView == displayCollection {
            if selected {
                displayCollection.removeTag(at: index)
                setNextButtonHighlight()
                checkError()
                // TODO: Not sure Mnemonic have same words or not
                // If so, need change this
                guard let findIndex = shuffled.firstIndex(of: tagText) else {
                    return
                }
                selectCollection.setTagAt(UInt(findIndex), selected: false)
                return
            }

            return
        }

        if !selected {
            selectCollection.setTagAt(index, selected: true)
            return
        }

        displayCollection.addTag(tagText)
        setNextButtonHighlight()
        checkError()
    }
}
