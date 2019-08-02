//
//  FaceIDHelper.swift
//  AliceX
//
//  Created by lmcmz on 25/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import PromiseKit
import LocalAuthentication

class FaceIDHelper {
    static let shared = FaceIDHelper()
    var isUsing: Bool = false
    
    func faceID() -> Promise<Void> {
        
        isUsing = true
        
        return Promise { seal in
            let myContext = LAContext()
            let myLocalizedReasonString = "Payment Verify"
            
            var authError: NSError?
            if #available(iOS 8.0, macOS 10.12.1, *) {
                if myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                    myContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                             localizedReason: myLocalizedReasonString)
                    { success, evaluateError in
                        
                        DispatchQueue.main.async {
                            if success {
                                // User authenticated successfully, take appropriate action
                                self.isUsing = false
                                seal.fulfill(())
                            } else {
                                // User did not authenticate successfully, look at error and take appropriate action
                                self.isUsing = false
                                seal.reject(evaluateError!)
                            }
                        }
                    }
                } else {
                    // Could not evaluate policy; look at authError and present an appropriate message to user
                    self.isUsing = false
                    seal.reject(authError!)
                }
            } else {
                // Fallback on earlier versions
                self.isUsing = false
                seal.reject(authError!)
            }
        }
    }
    
    func faceID(block: VoidBlock) {
//        FaceIDHelper
    }
}
