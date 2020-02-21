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
        
        let httpURL = mxString.hasPrefix("mxc://") ? MatrixManager.shared.media.url(ofContentThumbnail: mxString,
                                                                                    toFitViewSize: bounds.size,
                                                                                    with: MXThumbnailingMethodCrop): mxString
        
        guard let http = httpURL, let url = URL(string: http)  else {
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
