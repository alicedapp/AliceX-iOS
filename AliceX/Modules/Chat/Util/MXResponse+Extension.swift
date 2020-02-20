//
//  MXResponse+Extension.swift
//  AliceX
//
//  Created by lmcmz on 19/2/20.
//  Copyright © 2020 lmcmz. All rights reserved.
//

import Foundation
import SwiftMatrixSDK
import PromiseKit

extension MXResponse {
    func done(seal: Resolver<T>, successBlock: ((T) -> ())) {
        switch self {
        case .success(let object):
            successBlock(object)
            seal.fulfill(object)
        case .failure(let error):
            seal.reject(error)
        }
    }
    
    func done(seal: Resolver<T>) {
        switch self {
        case .success(let object):
            seal.fulfill(object)
        case .failure(let error):
            seal.reject(error)
        }
    }
}
