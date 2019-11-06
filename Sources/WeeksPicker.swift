//
//  WeeksPicker.swift
//
//  Copyright © 2019 Galina FABIO. All rights reserved.
//

import UIKit

struct RangeDaysOfWeek {
    var firstDay: Date
    var lastDay: Date
}

class WeeksPicker: UIControl {
    var firstDay: Date = Date()
    var lastDay: Date = Date()
    var selectedWeek: String?
    
    // MARK: - private variables
    
    fileprivate var date: Date = Date()
    fileprivate var calendar: Calendar = Calendar.autoupdatingCurrent
    fileprivate var locale: Locale? {
        didSet {
            calendar.locale = locale
        }
    }
    
    fileprivate lazy var pickerView: UIPickerView = {
        let picker = UIPickerView(frame: self.bounds)
        picker.delegate = self
        picker.dataSource = self
        picker.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return picker
    }()
    
    fileprivate lazy var weeks = [RangeDaysOfWeek]()
    
    // MARK: - Initialisation and configuration
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        config()
    }
    
    private func config() {
        addSubview(pickerView)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        getWeeks()
        setDate(date, animated: false)
    }
    
    private func getWeeks() {
        let minYear = calendar.component(.yearForWeekOfYear, from: date) - 5
        let maxYear = calendar.component(.yearForWeekOfYear, from: date) + 5
        
        for y in minYear...maxYear {
            let weeksInYear = calendar.range(of: .weekOfYear, in: .yearForWeekOfYear, for: CalendarFormatter.makeDate(year: y, month: 12, day: 31))
            var monday = CalendarFormatter.makeDate(year: y, month: 1, day: 1).startOfWeek!
            
            for _ in weeksInYear! {
                weeks.append(RangeDaysOfWeek(firstDay: monday, lastDay: CalendarFormatter.addWeeks(weeks: 1, to: monday, isForward: true)))
                monday = calendar.date(byAdding: .day, value: 1, to: monday.endOfWeek!)!
            }
        }
    }
    
    /// Select row in the picker with actual date
    ///
    open func setDate(_ date: Date, animated: Bool) {
        if let currentIndex = weeks.firstIndex(where: { $0.firstDay <= date && $0.lastDay >= date }) {
            pickerView.selectRow(currentIndex, inComponent: 0, animated: animated)
        }
    }
}

// MARK: - Extensions

extension WeeksPicker: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.date = weeks[row].firstDay
        self.firstDay = weeks[row].firstDay
        self.lastDay = weeks[row].lastDay
        self.selectedWeek = CalendarFormatter.weekDateFormatter.string(from: weeks[row].firstDay) + " - " + CalendarFormatter.weekDateFormatter.string(from: weeks[row].lastDay)
        sendActions(for: .valueChanged)
    }
}

extension WeeksPicker: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return weeks.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return CalendarFormatter.weekDateFormatter.string(from: weeks[row].firstDay) + " - " + CalendarFormatter.weekDateFormatter.string(from: weeks[row].lastDay)
    }
}
