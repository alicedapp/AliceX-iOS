//
//  TraitView.swift
//  AliceX
//
//  Created by lmcmz on 18/1/20.
//  Copyright © 2020 lmcmz. All rights reserved.
//

import UIKit

class TraitView: UIView {

    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var textLabel: UILabel!
    
    class func instanceFromNib() -> TraitView {
        let view = UINib(nibName: nameOfClass, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TraitView
//        view.configure()
        return view
    }
    
    override func awakeFromNib() {
        self.layer.shadowColor = UIColor(hex: "#000000", alpha: 0.5).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 5
    }
    
    func configure(type: String?, name: String?) {
        typeLabel.text = type?.split(separator: "_")
            .compactMap { String($0).firstCapitalized }
            .joined(separator: "").camelCaseToWords().uppercased()
        textLabel.text = name?.firstCapitalized
        self.sizeToFit()
    }
    
}
