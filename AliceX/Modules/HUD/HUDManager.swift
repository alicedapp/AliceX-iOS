//
//  HUDManager.swift
//  AliceX
//
//  Created by lmcmz on 26/6/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import QuickLayout
import SwiftEntryKit
import web3swift

class HUDManager: NSObject {
    static let shared = HUDManager()

    private override init() {}

    // MARK: - Error

    func showError(error: Error) {
        if let error = error as? WalletError {
            HUDManager.shared.showError(text: error.errorMessage)
        } else if let error = error as? Web3Error {
            HUDManager.shared.showError(text: error.errorDescription)
        } else {
            HUDManager.shared.showError(text: error.localizedDescription)
        }
    }

    func showErrorAlert(text: String, isAlert: Bool = false) {
        onMainThread {
            let view = SingleButtonAlertView.make(content: text, isAlert: isAlert)

            if #available(iOS 13.0, *) {
                view.overrideUserInterfaceStyle = (UIApplication.shared.keyWindow?.traitCollection.userInterfaceStyle)!
            }

            self.showAlertView(view: view,
                               backgroundColor: .clear,
                               haptic: .none,
                               type: .centerFloat,
                               widthIsFull: false,
                               canDismiss: true)
        }
    }

    func showError(text: String = "Error occur") {
        onMainThread {
            let style = EKProperty.LabelStyle(font: MainFont.light.with(size: 14), color: .white, alignment: .center)
            let labelContent = EKProperty.LabelContent(text: text, style: style)
            let imageContent = EKProperty.ImageContent(image: UIImage(named: "cross-white")!)
            let contentView = EKImageNoteMessageView(with: labelContent, imageContent: imageContent)

            var attributes: EKAttributes = EKAttributes()
            attributes = .topNote
            attributes.name = "Top Note"
            attributes.hapticFeedbackType = .error
            attributes.popBehavior = .animated(animation: .translation)
            attributes.entryBackground = .color(color: EKColor(UIColor(hex: "FF6565")))
            attributes.shadow = .active(with: .init(color: EKColor(UIColor(hex: "000000", alpha: 0.3)),
                                                    opacity: 0.5, radius: 2))
            attributes.statusBar = .light
            SwiftEntryKit.display(entry: contentView, using: attributes)
        }
    }

    // MARK: - Success

    func showSuccess(text: String = "Success") {
        onMainThread {
            let style = EKProperty.LabelStyle(font: MainFont.light.with(size: 14), color: .white, alignment: .center)
            let labelContent = EKProperty.LabelContent(text: text, style: style)
            let imageContent = EKProperty.ImageContent(image: UIImage(named: "tick-white")!)
            let contentView = EKImageNoteMessageView(with: labelContent, imageContent: imageContent)

            var attributes: EKAttributes = EKAttributes()
            attributes = .topNote
            attributes.name = "Top Note"
            attributes.hapticFeedbackType = .success
            attributes.popBehavior = .animated(animation: .translation)
            attributes.entryBackground = .color(color: EKColor(UIColor(hex: "7BCB26")))
            attributes.shadow = .active(with: .init(color: EKColor(UIColor(hex: "000000", alpha: 0.3)),
                                                    opacity: 0.5, radius: 2))
            attributes.statusBar = .light

            SwiftEntryKit.display(entry: contentView, using: attributes)
        }
    }

    // MARK: - View

    func showAlertView(view: UIView, backgroundColor: UIColor = .white,
                       haptic: EKAttributes.NotificationHapticFeedback = .none,
                       type: EKAttributes = .bottomFloat,
                       widthIsFull: Bool = true,
                       canDismiss: Bool = true) {
        onMainThread {
            var attributes: EKAttributes = EKAttributes()
            attributes = type
            attributes.hapticFeedbackType = haptic
            attributes.displayDuration = .infinity
            attributes.screenBackground = .color(color: EKColor(UIColor(white: 50.0 / 255.0, alpha: 0.3)))
            attributes.entryBackground = .color(color: EKColor(backgroundColor))
            attributes.screenInteraction = canDismiss ? .dismiss : .absorbTouches
            attributes.entryInteraction = .forward
            attributes.roundCorners = .top(radius: 20)
            attributes.scroll = .edgeCrossingDisabled(swipeable: canDismiss)
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

//            let edge = .constant(value: UIScreen.main.bounds.minEdge)
//            if widthIsFull {
//                edge = .constant(value: UIScreen.main.bounds.minEdge)
//            }
            attributes.positionConstraints.maxSize = .init(width: widthIsFull ?
                .constant(value: UIScreen.main.bounds.minEdge) : .ratio(value: 0.8),
                                                           height: .intrinsic)

            if #available(iOS 13.0, *) {
                view.overrideUserInterfaceStyle = (UIApplication.shared.keyWindow?.traitCollection.userInterfaceStyle)!
            }

            SwiftEntryKit.display(entry: view, using: attributes)
        }
    }

    // MARK: - View Controller

    func showAlertViewController(viewController: UIViewController) {
        onMainThread {
            var attributes: EKAttributes = EKAttributes()
            attributes = .bottomFloat
            attributes.displayDuration = .infinity
            attributes.screenBackground = .color(color: EKColor(UIColor(white: 50.0 / 255.0, alpha: 0.3)))
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
            attributes.displayMode = .inferred

            if #available(iOS 13.0, *) {
                viewController.overrideUserInterfaceStyle = (UIApplication.shared.keyWindow?.traitCollection.userInterfaceStyle)!
            }

            SwiftEntryKit.display(entry: viewController, using: attributes)
        }
    }

    func showAlertVCNoBackground(viewController: UIViewController, type: EKAttributes = .centerFloat, haveBG: Bool = false) {
        onMainThread {
            var attributes: EKAttributes = EKAttributes()
            attributes = type
            attributes.displayDuration = .infinity
            
            if haveBG {
                attributes.screenBackground = .color(color: EKColor(UIColor(white: 50.0 / 255.0, alpha: 0.3)))
            }
            
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
            attributes.displayMode = .inferred

            if #available(iOS 13.0, *) {
                viewController.overrideUserInterfaceStyle = (UIApplication.shared.keyWindow?.traitCollection.userInterfaceStyle)!
            }

            SwiftEntryKit.display(entry: viewController, using: attributes)
        }
    }

    func dismiss() {
        onMainThread {
            SwiftEntryKit.dismiss()
        }
    }
}
