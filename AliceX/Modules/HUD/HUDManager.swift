//
//  HUDManager.swift
//  AliceX
//
//  Created by lmcmz on 26/6/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import SwiftEntryKit
import QuickLayout

class HUDManager: NSObject {
    
    static let shared = HUDManager()
    
    private override init() {}
    
    func showError(text: String = "Error occur") {
        
        DispatchQueue.main.async {
            
            let style = EKProperty.LabelStyle(font: MainFont.light.with(size: 14), color: .white, alignment: .center)
            let labelContent = EKProperty.LabelContent(text: text, style: style)
            let imageContent = EKProperty.ImageContent(image: UIImage(named: "cross-white")!)
            let contentView = EKImageNoteMessageView(with: labelContent, imageContent: imageContent)
            
            var attributes: EKAttributes = EKAttributes()
            attributes = .topNote
            attributes.name = "Top Note"
            attributes.hapticFeedbackType = .error
            attributes.popBehavior = .animated(animation: .translation)
            attributes.entryBackground = .color(color: UIColor(hex: "FF6565"))
            attributes.shadow = .active(with: .init(color: UIColor(hex: "000000", alpha: 0.3), opacity: 0.5, radius: 2))
            attributes.statusBar = .light
            SwiftEntryKit.display(entry: contentView, using: attributes)
        }
    }
    
}
