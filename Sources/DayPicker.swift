//
//  DayPicker.swift
//  CalendarMenu
//
//  Created by Galina on 04/09/2020.
//

import UIKit

class DayPicker: UIControl {
    var date: Date = Date() {
        didSet {
            let newValue = calendar.startOfDay(for: date)
            setDate(newValue, animated: true)
            sendActions(for: .valueChanged)
        }
    }
    
    var calendar: Calendar = Calendar.autoupdatingCurrent {
        didSet {
            dayDateFormatter.calendar = calendar
            dayDateFormatter.timeZone = calendar.timeZone
            monthDateFormatter.calendar = calendar
            monthDateFormatter.timeZone = calendar.timeZone
            yearDateFormatter.calendar = calendar
            yearDateFormatter.timeZone = calendar.timeZone
        }
    }
    
    var locale: Locale? {
        didSet {
            calendar.locale = locale
            dayDateFormatter.locale = locale
            monthDateFormatter.locale = locale
            yearDateFormatter.locale = locale
        }
    }
    
    // MARK: - private variables
    
    fileprivate lazy var pickerView: UIPickerView = {
        let picker = UIPickerView(frame: self.bounds)
        picker.delegate = self
        picker.dataSource = self
        picker.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return picker
    }()
    
    fileprivate lazy var dayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("d")
        return formatter
    }()
    
    fileprivate lazy var monthDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MMMM")
        return formatter
    }()
    
    fileprivate lazy var yearDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("y")
        return formatter
    }()
    
    fileprivate enum Component: Int {
        case day
        case month
        case year
    }
    
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
        setDate(date, animated: false)
    }
    
    /// Select row in the picker with actual date
    ///
    open func setDate(_ date: Date, animated: Bool) {
        guard let yearRange = calendar.maximumRange(of: .year) else {
            return
        }
        guard let monthRange = calendar.maximumRange(of: .month) else {
            return
        }
        guard let dayRange = calendar.maximumRange(of: .day) else {
            return
        }
        
        let day = calendar.component(.day, from: date) - dayRange.lowerBound
        pickerView.selectRow(day, inComponent: Component.day.rawValue, animated: animated)
        
        let month = calendar.component(.month, from: date) - monthRange.lowerBound
        pickerView.selectRow(month, inComponent: Component.month.rawValue, animated: animated)
        
        let year = calendar.component(.year, from: date) - yearRange.lowerBound
        pickerView.selectRow(year, inComponent: Component.year.rawValue, animated: animated)
    }
}

// MARK: - Extensions

extension DayPicker: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let yearRange = calendar.maximumRange(of: .year),
              let monthRange = calendar.maximumRange(of: .month),
              let dayRange = calendar.maximumRange(of: .day) else {
            return
        }
        var dateComponents = DateComponents()
        
        dateComponents.year = yearRange.lowerBound + pickerView.selectedRow(inComponent: Component.year.rawValue)
        dateComponents.month = monthRange.lowerBound + pickerView.selectedRow(inComponent: Component.month.rawValue)
        dateComponents.day = dayRange.lowerBound + pickerView.selectedRow(inComponent: Component.day.rawValue)
        
        guard let date = calendar.date(from: dateComponents) else {
            return
        }
        self.date = date
    }
}

extension DayPicker: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let pickerComponent = Component(rawValue: component) else { return 0 }
        
        switch pickerComponent {
        case .day:
            guard let range = calendar.maximumRange(of: .day) else {
                return 0
            }
            return range.count
        case .month:
            guard let range = calendar.maximumRange(of: .month) else {
                return 0
            }
            return range.count
        case .year:
            guard let range = calendar.maximumRange(of: .year) else {
                return 0
            }
            return range.count
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let pickerComponent = Component(rawValue: component) else { return nil }
        
        switch pickerComponent {
        case .day:
            guard let range = calendar.maximumRange(of: .day) else {
                return nil
            }
            let day = range.lowerBound + row
            var dateComponents = DateComponents()
            
            dateComponents.day = day
            guard let date = calendar.date(from: dateComponents) else {
                return nil
            }
            
            return dayDateFormatter.string(from: date)
        case .month:
            guard let range = calendar.maximumRange(of: .month) else {
                return nil
            }
            let month = range.lowerBound + row
            var dateComponents = DateComponents()
            
            dateComponents.month = month
            guard let date = calendar.date(from: dateComponents) else {
                return nil
            }
            
            return monthDateFormatter.string(from: date)
        case .year:
            guard let range = calendar.maximumRange(of: .year) else {
                return nil
            }
            let year = range.lowerBound + row
            var dateComponents = DateComponents()
            
            dateComponents.year = year
            guard let date = calendar.date(from: dateComponents) else {
                return nil
            }
            
            return yearDateFormatter.string(from: date)
        }
    }
}

