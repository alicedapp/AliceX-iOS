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
    
    func showSuccess(text: String = "Success") {
        DispatchQueue.main.async {
            
            let style = EKProperty.LabelStyle(font: MainFont.light.with(size: 14), color: .white, alignment: .center)
            let labelContent = EKProperty.LabelContent(text: text, style: style)
            let imageContent = EKProperty.ImageContent(image: UIImage(named: "tick-white")!)
            let contentView = EKImageNoteMessageView(with: labelContent, imageContent: imageContent)
            
            var attributes: EKAttributes = EKAttributes()
            attributes = .topNote
            attributes.name = "Top Note"
            attributes.hapticFeedbackType = .success
            attributes.popBehavior = .animated(animation: .translation)
            attributes.entryBackground = .color(color: UIColor(hex: "7BCB26"))
            attributes.shadow = .active(with: .init(color: UIColor(hex: "000000", alpha: 0.3), opacity: 0.5, radius: 2))
            attributes.statusBar = .light
            
            SwiftEntryKit.display(entry: contentView, using: attributes)
        }
    }
    
    func showAlertView(view: UIView, backgroundColor: UIColor = .white,
                       haptic:EKAttributes.NotificationHapticFeedback = .none ) {
        
        DispatchQueue.main.async {
            
            var attributes: EKAttributes = EKAttributes()
            attributes = .bottomFloat
            attributes.hapticFeedbackType = haptic
            attributes.displayDuration = .infinity
            attributes.screenBackground = .color(color: UIColor(white: 100.0/255.0, alpha: 0.3))
            attributes.entryBackground = .color(color: backgroundColor)
            attributes.screenInteraction = .dismiss
            attributes.entryInteraction = .forward
            attributes.roundCorners = .top(radius: 20)
            attributes.scroll = .edgeCrossingDisabled(swipeable: true)
            attributes.statusBar = .currentStatusBar
            attributes.entranceAnimation = .init(translate: .init(duration: 0.5, spring: .init(damping: 0.9, initialVelocity: 0)))
            attributes.exitAnimation = .init(translate: .init(duration: 0.3))
            attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3),
                                                                scale: .init(from: 1, to: 0.8, duration: 0.3)))
            attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 6))
            attributes.positionConstraints.verticalOffset = 0
            attributes.positionConstraints.size = .init(width: .offset(value: 0), height: .fill)
            attributes.positionConstraints.safeArea = .overridden
//                .empty(fillSafeArea: true)
            attributes.positionConstraints.maxSize = .init(width:
                .constant(value: UIScreen.main.bounds.minEdge), height: .intrinsic)
            
            SwiftEntryKit.display(entry: view, using: attributes)
        }
    }
    
    func showAlertViewController(viewController: UIViewController) {
        
        DispatchQueue.main.async {
            
            var attributes: EKAttributes = EKAttributes()
            attributes = .bottomFloat
            attributes.displayDuration = .infinity
            attributes.screenBackground = .color(color: UIColor(white: 50.0/255.0, alpha: 0.3))
            attributes.entryBackground = .color(color: .white)
            attributes.screenInteraction = .dismiss
            attributes.entryInteraction = .absorbTouches
            attributes.scroll = .edgeCrossingDisabled(swipeable: true)
            
            attributes.entranceAnimation = .init(translate: .init(duration: 0.5, spring: .init(damping: 1, initialVelocity: 0)))
            attributes.exitAnimation = .init(translate: .init(duration: 0.35))
            attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.35)))
            attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 6))
            attributes.positionConstraints.size = .init(width: .fill, height: .ratio(value: 0.6))
            attributes.positionConstraints.verticalOffset = 0
            attributes.positionConstraints.safeArea = .overridden
            
            SwiftEntryKit.display(entry: viewController, using: attributes)
        }
    }
    
    func showAlertVCNoBackground(viewController: UIViewController, type: EKAttributes = .centerFloat ) {
        
        DispatchQueue.main.async {
            
            var attributes: EKAttributes = EKAttributes()
            attributes = type
            attributes.displayDuration = .infinity
            attributes.screenBackground = .color(color: UIColor(white: 50.0/255.0, alpha: 0.3))
            attributes.entryBackground = .color(color: .clear)
            attributes.screenInteraction = .dismiss
            attributes.entryInteraction = .absorbTouches
            attributes.scroll = .edgeCrossingDisabled(swipeable: true)
            attributes.statusBar = .currentStatusBar
            
            attributes.entranceAnimation = .init(translate: .init(duration: 0.5, spring: .init(damping: 1, initialVelocity: 0)))
            attributes.exitAnimation = .init(translate: .init(duration: 0.35))
            attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.35)))
            attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 6))
            attributes.positionConstraints.size = .init(width: .fill, height: .fill)
            attributes.positionConstraints.verticalOffset = 0
            attributes.positionConstraints.safeArea = .empty(fillSafeArea: false)
            
            attributes.positionConstraints.keyboardRelation = .bind(offset: .init(bottom: 10, screenEdgeResistance: 5))
            
            SwiftEntryKit.display(entry: viewController, using: attributes)
        }
    }
    
    func dismiss() {
        DispatchQueue.main.async {
            SwiftEntryKit.dismiss()
        }
    }
}
