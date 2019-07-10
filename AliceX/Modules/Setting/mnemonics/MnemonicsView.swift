//
//  MnemonicsView.swift
//  AliceX
//
//  Created by lmcmz on 3/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit

class MnemonicsView: UIView {
    
    @IBOutlet weak var secretView: UITextView!
    
    var isShown: Bool = false
    var secertText = "🎩👱‍♀️🐇🕳   ✨😺 🤡☕     🍰🧁💨🐛    🐇🕒🏰    ♠️♣️❤️👸"
    let mnemonics = KeychainHepler.shared.fetchKeychain(key: Setting.MnemonicsKey)
    
    class func instanceFromNib() -> MnemonicsView {
        let view = UINib(nibName: self.nameOfClass, bundle: nil)
            .instantiate(withOwner: nil, options: nil)[0] as! MnemonicsView
        return view
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.roundCorners(corners: [.topLeft, .topRight], radius: 10)
        secretView.text = secertText
    }
    
    @IBAction func copyClicked() {
        UIPasteboard.general.string = mnemonics
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    @IBAction func showClicked() {
        isShown = !isShown
        updateText()
    }
    
    func updateText() {
        if isShown {
            secretView.text = mnemonics
            return
        }
        
        secretView.text = secertText
    }
    
}
