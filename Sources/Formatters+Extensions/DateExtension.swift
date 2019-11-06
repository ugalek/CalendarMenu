//
//  DateExtension.swift
//
//  Copyright © 2019 Galina FABIO. All rights reserved.
//

import Foundation

public extension Date {
    
    private var calendar: Calendar {
        return Calendar.current
    }
 
    /// Returns start of the day.
    var startOfDay: Date {
        return calendar.startOfDay(for: self)
    }
    
    /// Returns next day of the given date.
    var nextDay: Date {
        var components = DateComponents()
        components.day = 1
        return calendar.date(byAdding: components, to: startOfDay)!
    }
    
    /// Returns a date with start of the current week
    var startOfWeek: Date? {
        guard let sunday = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        if calendar.component(.weekday, from: self) == 2 {
            return self
        }
        return calendar.date(byAdding: .day, value: 1, to: sunday)
    }
    
    /// Returns a date with end of the current week.
    var endOfWeek: Date? {
        guard let sunday = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        if calendar.component(.weekday, from: self) == 7 {
            return self
        }
        return calendar.date(byAdding: .day, value: 7, to: sunday)
    }
    
    /// Returns start of the current month.
    var startOfMonth: Date {
        guard let lastDay = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self)) else { return Date() }
        return lastDay.nextDay
    }
}
