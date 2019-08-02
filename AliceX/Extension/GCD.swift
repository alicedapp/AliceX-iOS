//
//  GCD.swift
//  AliceX
//
//  Created by lmcmz on 26/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation

typealias DelayTask = (_ cancel: Bool) -> Void

func delay(_ time: TimeInterval, task: @escaping () -> Void) -> DelayTask? {
    func dispatch_later(block: @escaping () -> Void) {
        let t = DispatchTime.now() + time
        DispatchQueue.main.asyncAfter(deadline: t, execute: block)
    }
    var closure: (() -> Void)? = task
    var result: DelayTask?
    let delayedClosure: DelayTask = { cancel in
        if let internalClosure = closure {
            if cancel == false {
                DispatchQueue.main.async(execute: internalClosure)
            }
        }
        closure = nil
        result = nil
    }
    result = delayedClosure
    dispatch_later {
        if let delayedClosure = result {
            delayedClosure(false)
        }
    }
    return result
}

func cancel(_ task: DelayTask?) {
    task?(true)
}

extension DispatchQueue {
    static func background(delay: Double = 0.0, background: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    background?()
                    completion()
                }
            }
        }
    }
}
