//
//  UIImage.swift
//  AliceX
//
//  Created by lmcmz on 14/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit

extension UIImage {
    class func imageWithColor(color: UIColor) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    func filled(with color: UIColor) -> UIImage {
        let rect = CGRect(origin: .zero, size: self.size)
        guard let mask = self.cgImage else { return self }

        if #available(iOS 10.0, *) {
            let rendererFormat = UIGraphicsImageRendererFormat()
            rendererFormat.scale = self.scale

            let renderer = UIGraphicsImageRenderer(size: rect.size,
                                                   format: rendererFormat)
            return renderer.image { context in
                context.cgContext.fill(rect,
                                       with: mask,
                                       using: color.cgColor)
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(rect.size,
                                                   false,
                                                   self.scale)
            defer { UIGraphicsEndImageContext() }

            guard let context = UIGraphicsGetCurrentContext() else { return self }

            context.fill(rect,
                         with: mask,
                         using: color.cgColor)
            return UIGraphicsGetImageFromCurrentImageContext() ?? self
        }
    }
    
    func toString() -> String? {
        let data: Data? = self.pngData()
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
}


extension CGContext {

    func fill(_ rect: CGRect,
              with mask: CGImage,
              using color: CGColor) {

        saveGState()
        defer { restoreGState() }

        translateBy(x: 0.0, y: rect.size.height)
        scaleBy(x: 1.0, y: -1.0)
        setBlendMode(.normal)

        clip(to: rect, mask: mask)

        setFillColor(color)
        fill(rect)
    }
}
