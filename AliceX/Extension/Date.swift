//
//  Date.swift
//  AliceX
//
//  Created by lmcmz on 7/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation

extension Date {
    static func getTimeComponentString(olderDate older: Date, newerDate newer: Date) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full

        let componentsLeftTime = Calendar.current.dateComponents([.second, .minute, .hour, .day, .month, .weekOfMonth, .year], from: older, to: newer)

        let year = componentsLeftTime.year ?? 0
        if year > 0 {
            formatter.allowedUnits = [.year]
            return formatter.string(from: older, to: newer)
        }

        let month = componentsLeftTime.month ?? 0
        if month > 0 {
            formatter.allowedUnits = [.month]
            return formatter.string(from: older, to: newer)
        }

        let weekOfMonth = componentsLeftTime.weekOfMonth ?? 0
        if weekOfMonth > 0 {
            formatter.allowedUnits = [.weekOfMonth]
            return formatter.string(from: older, to: newer)
        }

        let day = componentsLeftTime.day ?? 0
        if day > 0 {
            formatter.allowedUnits = [.day]
            return formatter.string(from: older, to: newer)
        }

        let hour = componentsLeftTime.hour ?? 0
        if hour > 0 {
            formatter.allowedUnits = [.hour]
            return formatter.string(from: older, to: newer)
        }

        let minute = componentsLeftTime.minute ?? 0
        if minute > 0 {
            formatter.allowedUnits = [.minute]
            return formatter.string(from: older, to: newer)
        }

        let second = componentsLeftTime.second ?? 0
        if second > 0 {
            //            formatter.allowedUnits = [.minute]
            //                formatter.string(from: older, to: newer) ?? ""
            return "Just now"
        }

        return "Just now"
    }
}

extension Date {
    
    func formatToString(format: String = "dd/MM/yy" ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

    func isEqual(to date: Date, toGranularity component: Calendar.Component, in calendar: Calendar = .current) -> Bool {
        calendar.isDate(self, equalTo: date, toGranularity: component)
    }

    func isInSameYear (date: Date) -> Bool { isEqual(to: date, toGranularity: .year) }
    func isInSameMonth(date: Date) -> Bool { isEqual(to: date, toGranularity: .month) }
    func isInSameDay  (date: Date) -> Bool { isEqual(to: date, toGranularity: .day) }
    func isInSameWeek (date: Date) -> Bool { isEqual(to: date, toGranularity: .weekOfYear) }

    var isInThisYear:  Bool { isInSameYear(date: Date()) }
    var isInThisMonth: Bool { isInSameMonth(date: Date()) }
    var isInThisWeek:  Bool { isInSameWeek(date: Date()) }

    var isInYesterday: Bool { Calendar.current.isDateInYesterday(self) }
    var isInToday:     Bool { Calendar.current.isDateInToday(self) }
    var isInTomorrow:  Bool { Calendar.current.isDateInTomorrow(self) }

    var isInTheFuture: Bool { self > Date() }
    var isInThePast:   Bool { self < Date() }
}
