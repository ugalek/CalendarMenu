//
//  ViewController.swift
//  CalendarMenu
//
//  Copyright (c) 2019 Galina FABIO. All rights reserved.
//

import UIKit
import CalendarMenu

class ViewController: UIViewController {
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var cMenu: CalendarMenu!
    
    var calendarInterval = CalendarMenu.CalendarInterval.Day
    var dateOfCalendar = Date()
    var firstDayOfCalendar: Date?
    var lastDayOfCalendar: Date?
    var monthOfCalendar = Date()
    
    /// Formatter with format: dd MMMM yyyy
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cMenu.style.fontDateInterval = UIFont.systemFont(ofSize: 17.0, weight: .light)
        dateField.text = dateFormatter.string(from: dateOfCalendar)
        dateField.delegate = self
        dateField.addTarget(self, action: #selector(textFieldTapped), for: .touchDown)
        cMenu.addTarget(self, action: #selector(cMenuValueChanged), for: .valueChanged)
    }
    
    private func configCalendarMenu() {
        switch calendarInterval {
        case .Day:
            cMenu.dayOfCalendar = dateOfCalendar
            cMenu.calendarInterval = .Day
        case .Week:
            cMenu.firstDayOfCalendar = firstDayOfCalendar
            cMenu.lastDayOfCalendar = lastDayOfCalendar
            cMenu.calendarInterval = .Week
        case .Month:
            cMenu.monthOfCalendar = monthOfCalendar
            cMenu.calendarInterval = .Month
        }
    }
    
    @objc func textFieldTapped() {
        configCalendarMenu()
        cMenu.showCalendarMenu()
    }
    
    @objc func cMenuValueChanged() {
        calendarInterval = cMenu.calendarInterval
        dateField.text = cMenu.dateIntervalLabel.text
        switch calendarInterval {
        case .Day:
            dateOfCalendar = cMenu.dayOfCalendar ?? Date()
        case .Week:
            firstDayOfCalendar = cMenu.firstDayOfCalendar
            lastDayOfCalendar = cMenu.lastDayOfCalendar
        case .Month:
            monthOfCalendar = cMenu.monthOfCalendar ?? Date().startOfMonth
        }
    }
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == dateField {
            return false
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
}
