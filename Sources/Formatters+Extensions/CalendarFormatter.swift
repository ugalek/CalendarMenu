//
//  CalendarFormatter.swift
//
//  Copyright © 2019 Galina FABIO. All rights reserved.
//

import Foundation

class CalendarFormatter {
    /// Formatter with format: dd MMMM yyyy
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }()
    
    /// Formatter with format: MMMM yyyy
    static var monthDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MMMM yyyy")
        return formatter
    }()

    /// Formatter with format: dd.MM.yyyy
    static var weekDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"

        return formatter
    }()
    
    /// Adds the number of weeks to the specified date.
    ///
    /// - Parameter weeks: - Number of weeks
    /// - Parameter to: - Date to which you want to add a weeks
    /// - Parameter isForward: - Direction of operation `True` - add week, `False` - take away
    ///
    /// - Returns: Calculated date
    ///
    static func addWeeks(weeks: Int, to date: Date, isForward: Bool) -> Date {
        var calendar: Calendar {
            return Calendar.current
        }
        var components = DateComponents()
        components.day = (7 * weeks) * (isForward ? 1 : -1) - (isForward ? 1 : 0)
        return calendar.date(byAdding: components, to: date, wrappingComponents: false) ?? Date()
    }
    
    /// Make a Date object with given data
    ///
    /// - Returns: Calculated or current date
    ///
    static func makeDate(year: Int, month: Int, day: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.timeZone = TimeZone(secondsFromGMT: 0)
        
        let userCalendar = Calendar.current
        return userCalendar.date(from: dateComponents) ?? Date()
    }
}
