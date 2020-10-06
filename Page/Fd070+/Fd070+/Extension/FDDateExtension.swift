//
//  FDDateExtension.swift
//  FD070+
//
//  Created by HaiQuan on 2018/12/27.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import Foundation

extension Date {

    var startOfDay : Date {
        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([.year, .month, .day])
        let components = calendar.dateComponents(unitFlags, from: self)
        return calendar.date(from: components)!
    }
    var endOfDay : Date {
        var components = DateComponents()
        components.day = 1
        let date = Calendar.current.date(byAdding: components, to: self.startOfDay)
        return (date?.addingTimeInterval(-1))!
    }

    var startOfMonth : Date {
        let calendar = Calendar(identifier: Calendar.current.identifier)
        let unitFlags = Set<Calendar.Component>([.year, .month])
        let components = calendar.dateComponents(unitFlags, from: self)
        return calendar.date(from: components)!
    }
    var endOfMonth : Date {
        var components = DateComponents()

         components.month = 1
        let date = Calendar.current.date(byAdding: components, to: self.startOfMonth)
        return (date?.addingTimeInterval(-1))!
    }

    var startOfYear : Date {
        let calendar = Calendar(identifier: Calendar.current.identifier)
        let unitFlags = Set<Calendar.Component>([.year])
        let components = calendar.dateComponents(unitFlags, from: self)
        return calendar.date(from: components)!
    }
    var endOfYear : Date {
        var components = DateComponents()
        components.year = 1
        
        let date = Calendar.current.date(byAdding: components, to: self.startOfYear)
        return (date?.addingTimeInterval(-1))!
    }

    ///get number of sceonds between two date
    ///
    /// - Parameter date: date to compate self to.
    /// - Returns: number of days between self and given date.
    public func sceondsSince(_ date: Date) -> Double {
        return timeIntervalSince(date)
    }
    ///get number of days between two date
    ///
    /// - Parameter date: date to compate self to.
    /// - Returns: number of days between self and given date.
    public func daysSince(_ date: Date) -> Double {
        return timeIntervalSince(date)/(3600*24)
    }

    func dateByAddingDays(byAddingDays days: Int) -> Date? {
        let calendar = Calendar.current
        var components = DateComponents()
        components.day = days
        return  calendar.date(byAdding: components, to: self)
    }
    /// SwifterSwift: Year.
    ///
    ///        Date().year -> 2017
    ///
    ///        var someDate = Date()
    ///        someDate.year = 2000 // sets someDate's year to 2000
    ///
    var year: Int {
        get {
            return Calendar.current.component(.year, from: self)
        }
        set {
            guard newValue > 0 else { return }
            let currentYear = Calendar.current.component(.year, from: self)
            let yearsToAdd = newValue - currentYear
            if let date = Calendar.current.date(byAdding: .year, value: yearsToAdd, to: self) {
                self = date
            }
        }
    }
    /// SwifterSwift: Hour.
    ///
    ///     Date().hour -> 17 // 5 pm
    ///
    ///     var someDate = Date()
    ///     someDate.hour = 13 // sets someDate's hour to 1 pm.
    ///
    var hour: Int {
        get {
            return Calendar.current.component(.hour, from: self)
        }
        set {
            let allowedRange = Calendar.current.range(of: .hour, in: .day, for: self)!
            guard allowedRange.contains(newValue) else { return }

            let currentHour = Calendar.current.component(.hour, from: self)
            let hoursToAdd = newValue - currentHour
            if let date = Calendar.current.date(byAdding: .hour, value: hoursToAdd, to: self) {
                self = date
            }
        }
    }

    /// SwifterSwift: Minutes.
    ///
    ///     Date().minute -> 39
    ///
    ///     var someDate = Date()
    ///     someDate.minute = 10 // sets someDate's minutes to 10.
    ///
    public var minute: Int {
        get {
            return Calendar.current.component(.minute, from: self)
        }
        set {
            let allowedRange = Calendar.current.range(of: .minute, in: .hour, for: self)!
            guard allowedRange.contains(newValue) else { return }

            let currentMinutes = Calendar.current.component(.minute, from: self)
            let minutesToAdd = newValue - currentMinutes
            if let date = Calendar.current.date(byAdding: .minute, value: minutesToAdd, to: self) {
                self = date
            }
        }
    }

    /// SwifterSwift: Seconds.
    ///
    ///     Date().second -> 55
    ///
    ///     var someDate = Date()
    ///     someDate.second = 15 // sets someDate's seconds to 15.
    ///
    public var second: Int {
        get {
            return Calendar.current.component(.second, from: self)
        }
        set {
            let allowedRange = Calendar.current.range(of: .second, in: .minute, for: self)!
            guard allowedRange.contains(newValue) else { return }

            let currentSeconds = Calendar.current.component(.second, from: self)
            let secondsToAdd = newValue - currentSeconds
            if let date = Calendar.current.date(byAdding: .second, value: secondsToAdd, to: self) {
                self = date
            }
        }
    }

    static var timeStamp : String {
        
        let date = Date(timeIntervalSinceNow: 0)
        let a = date.timeIntervalSince1970
        let timeStp = String.init(format: "%.f", a)
        
        return timeStp
    }

    var startOfDayTimestamp: String {

        return String.init(format: "%.f", self.startOfDay.timeIntervalSince1970)
    }

}

