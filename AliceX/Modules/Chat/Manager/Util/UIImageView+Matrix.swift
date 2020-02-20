//
//  UIImageView+Matrix.swift
//  AliceX
//
//  Created by lmcmz on 20/2/20.
//  Copyright © 2020 lmcmz. All rights reserved.
//

import Foundation
import Kingfisher
import SwiftMatrixSDK

extension UIImageView {
//    class mx {
//    }
    
    func setMXImage(mxString: String) {
        
        guard let httpURL = MatrixManager.shared.media.url(ofContentThumbnail: mxString,
                                                        toFitViewSize: bounds.size,
                                                        with: MXThumbnailingMethodScale),
            let url = URL(string: httpURL)  else {
            return
        }
        kf.setImage(with: url) { response in
            switch response {
            case .success:
                self.backgroundColor = .clear
            case .failure:
                break
            }
        }
        
    }
    
}
