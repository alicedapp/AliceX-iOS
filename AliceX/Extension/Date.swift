//
//  Date.swift
//  AliceX
//
//  Created by lmcmz on 7/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation

extension Date {
    
    func getTimeComponentString(olderDate older: Date,newerDate newer: Date) -> (String?)  {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full

        let componentsLeftTime = Calendar.current.dateComponents([.minute , .hour , .day,.month, .weekOfMonth,.year], from: older, to: newer)

        let year = componentsLeftTime.year ?? 0
        if  year > 0 {
            formatter.allowedUnits = [.year]
            return formatter.string(from: older, to: newer)
        }

        let month = componentsLeftTime.month ?? 0
        if  month > 0 {
            formatter.allowedUnits = [.month]
            return formatter.string(from: older, to: newer)
        }

        let weekOfMonth = componentsLeftTime.weekOfMonth ?? 0
        if  weekOfMonth > 0 {
            formatter.allowedUnits = [.weekOfMonth]
            return formatter.string(from: older, to: newer)
        }

        let day = componentsLeftTime.day ?? 0
        if  day > 0 {
            formatter.allowedUnits = [.day]
            return formatter.string(from: older, to: newer)
        }

        let hour = componentsLeftTime.hour ?? 0
        if  hour > 0 {
            formatter.allowedUnits = [.hour]
            return formatter.string(from: older, to: newer)
        }

        let minute = componentsLeftTime.minute ?? 0
        if  minute > 0 {
            formatter.allowedUnits = [.minute]
            return formatter.string(from: older, to: newer) ?? ""
        }

        return nil
    }
    
}
