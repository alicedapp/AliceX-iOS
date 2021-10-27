//
//  LandingViewController.swift
//  AliceX
//
//  Created by lmcmz on 1/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import BigInt
import BonMot
import SPStorkController
import UIKit
import VBFPopFlatButton
import web3swift

class LandingViewController: BaseViewController {
    @IBOutlet var importBtn: BaseControl!

    @IBOutlet var conditionContainer: UIView!
    @IBOutlet var checkBox: VBFPopFlatButton!
    @IBOutlet var conditionLabel: UILabel!

    var isChecked: Bool = false

    var checkBoxFrame: CGRect!

    override func viewDidLoad() {
        super.viewDidLoad()
        hero.isEnabled = true
        importBtn.hero.id = "importWallet"

        checkBox.currentButtonType = .buttonSquareType
        checkBox.currentButtonStyle = .buttonRoundedStyle
        checkBox.lineThickness = 3
        checkBox.lineRadius = 3
        checkBox.tintColor = AliceColor.darkGrey()

        let blueStyle = StringStyle(
            .color(AliceColor.blue),
            .font(UIFont.systemFont(ofSize: 15, weight: .bold))
            //            .underline(.patternDashDot, .blue)
        )

        let fishStyle = StringStyle(
            .font(UIFont.systemFont(ofSize: 15)),
            .lineHeightMultiple(1.2),
            .color(AliceColor.darkGrey()),
            .xmlRules([
                .style("blue", blueStyle)
            ])
        )

        let content = "I agree to the Zed Labs' <blue>Terms of Service</blue> and <blue>Privacy Policy</blue>."
        let attributedString = content.styled(with: fishStyle)
        conditionLabel.attributedText = attributedString

        checkBox.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        let tap = UITapGestureRecognizer(target: self, action: #selector(tapLabel(gesture:)))
        conditionLabel.addGestureRecognizer(tap)
    }

    override func viewDidLayoutSubviews() {
        checkBoxFrame = checkBox.frame
    }

    @IBAction func checkClicked() {
        isChecked = !isChecked
        if isChecked {
            checkBox.currentButtonType = .buttonOkType
            checkBox.tintColor = AliceColor.green
            UIView.animate(withDuration: 0.3) {
                self.checkBox.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
                //                self.checkBox.frame = CGRect(x: self.checkBoxFrame.minX,
                //                                             y: self.checkBoxFrame.minY,
                //                                             width: self.checkBoxFrame.width*0.6,
                //                                             height: self.checkBoxFrame.height*0.6)
                //
                //                self.checkBox.center = CGPoint(x: self.checkBoxFrame.midX, y: self.checkBoxFrame.midY)
            }
            return
        }

        checkBox.currentButtonType = .buttonSquareType
        checkBox.tintColor = UIColor.gray

        UIView.animate(withDuration: 0.3) {
            self.checkBox.transform = .identity
            //            self.checkBox.frame = self.checkBoxFrame
        }
    }

    @IBAction func createButtonClicked() {
        if !isChecked {
            shakeAnimation()
            return
        }

        WalletManager.createWallet { () -> Void in
            self.popUp()
            WalletCore.shared.loadFromCache()
        }
    }

    @IBAction func importButtonClicked() {
        if !isChecked {
            shakeAnimation()
            return
        }

        let vc = ImportWalletViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func tapLabel(gesture: UITapGestureRecognizer) {
        let text = conditionLabel.text!
        let termsRange = (text as NSString).range(of: "Terms of Service")
        let privacyRange = (text as NSString).range(of: "Privacy Policy")

        if gesture.didTapAttributedTextInLabel(label: conditionLabel, inRange: termsRange) {
            let vc = SampleBrowserViewController.make(url: Setting.termURL, title: "Terms of Service")
            presentAsStork(vc, height: nil, showIndicator: false, showCloseButton: false)
        } else if gesture.didTapAttributedTextInLabel(label: conditionLabel, inRange: privacyRange) {
            let vc = SampleBrowserViewController.make(url: Setting.privacyURL, title: "Privacy Policy")
            presentAsStork(vc, height: nil, showIndicator: false, showCloseButton: false)
        } else {
            print("Tapped none")
        }
    }

    func shakeAnimation() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()

        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.repeatCount = 3
        animation.duration = 0.2 / TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.values = [3, -3]
        conditionContainer.layer.add(animation, forKey: "shake")

        UIView.animate(withDuration: 0.2, animations: {
            self.checkBox.tintColor = AliceColor.red
        }) { _ in
            self.checkBox.tintColor = AliceColor.darkGrey()
        }
    }

    func popUp() {
        let vc = MainTabViewController()
        navigationController?.pushViewController(vc, animated: true)
        navigationController?.viewControllers = [vc]
    }
}
