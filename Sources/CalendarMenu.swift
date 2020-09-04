//
//  CalendarMenu.swift
//
//  Copyright © 2019 Galina FABIO. All rights reserved.
//

import UIKit

/// Set stile to the UIControl
///
public struct CalendarMenuStyle {
    public var bgColor: UIColor = UIColor(red: 247 / 255.0, green: 246 / 255.0, blue: 240 / 255.0, alpha: 1.0)
    public var fontDateInterval: UIFont = UIFont.systemFont(ofSize: 17.0)
    public var segmentControlTintColor: UIColor = UIColor(red: 188 / 255, green: 165 / 255, blue: 146 / 255, alpha: 1)
    public var selectedSegmentTintColor: UIColor = UIColor(red: 188 / 255, green: 165 / 255, blue: 146 / 255, alpha: 1)
    public var buttonTintColor: UIColor = UIColor(red: 161 / 255, green: 89 / 255, blue: 21 / 255, alpha: 1)
    public var buttonBorderColor: UIColor = UIColor(red: 188 / 255, green: 165 / 255, blue: 146 / 255, alpha: 1)
}

@IBDesignable
open class CalendarMenu: UIControl {
    // MARK: - Public variables
    
    open var style: CalendarMenuStyle {
        didSet {
            configViews()
        }
    }
    
    public var dayOfCalendar: Date? {
        didSet {
            if let day = dayOfCalendar {
               // datePicker.date = day
                datePicker.setDate(day, animated: true)
            }
        }
    }
    
    public var monthOfCalendar: Date? {
        didSet {
            if let month = monthOfCalendar {
                monthYearPicker.setDate(month, animated: true)
            }
        }
    }
    
    public var firstDayOfCalendar: Date? {
        didSet {
            if let firstDay = firstDayOfCalendar {
                weeksPicker.setDate(firstDay, animated: true)
            }
        }
    }
    
    public var lastDayOfCalendar: Date?
    
    public enum CalendarInterval {
        case Day
        case Week
        case Month
    }
    
    public var calendarInterval = CalendarInterval.Day
    
    /// Contains 3 values that can be localized with `NSLocalizedString`
    ///
    /// - Parameter Day
    /// - Parameter Week
    /// - Parameter Month
    ///
    public let segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: [
            NSLocalizedString("Day", comment: ""),
            NSLocalizedString("Week", comment: ""),
            NSLocalizedString("Month", comment: ""),
        ])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.selectedSegmentIndex = 0
        
        return sc
    }()
    
    /// Label with configured date
    public var dateIntervalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "dd MMMM yyyy"
        
        return label
    }()
    
    // MARK: - Private variables
    
    private let blackView: UIView = {
        let bv = UIView()
        bv.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return bv
    }()
    
    private let menuView: UIView = {
        let mv = UIView()
        mv.alpha = 0
        return mv
    }()
    
    private let todayButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 5
        button.setTitle(NSLocalizedString("Today", comment: ""), for: .normal)
        
        return button
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 5
        button.setTitle("OK", for: .normal)
        
        return button
    }()
    
    private let containerPickerView: UIView = {
        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.clipsToBounds = true
        
        return cv
    }()
    
    private let datePicker: DayPicker = {
        let picker = DayPicker(frame: CGRect(origin: CGPoint(x: 0, y: 0),
                                                   size: CGSize(width: 50, height: 50)))
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.backgroundColor = .clear
        picker.layer.masksToBounds = true
        return picker
    }()
    
    private let monthYearPicker: MonthYearPicker = {
        let picker = MonthYearPicker(frame: CGRect(origin: CGPoint(x: 0, y: 0),
                                                   size: CGSize(width: 50, height: 50)))
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.backgroundColor = .clear
        picker.layer.masksToBounds = true
        return picker
    }()
    
    private let weeksPicker: WeeksPicker = {
        let picker = WeeksPicker(frame: CGRect(origin: CGPoint(x: 0, y: 0),
                                               size: CGSize(width: 50, height: 50)))
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.backgroundColor = .clear
        picker.layer.masksToBounds = true
        return picker
    }()
    
    // MARK: - Initialisation
    
    // init from viewcontroller
    public convenience override init(frame: CGRect) {
        self.init(frame: frame, segmentStyle: CalendarMenuStyle())
    }
    
    public init(frame: CGRect, segmentStyle: CalendarMenuStyle) {
        style = segmentStyle
        super.init(frame: frame)
        configViews()
    }
    
    // init from interface builder
    public required init?(coder aDecoder: NSCoder) {
        style = CalendarMenuStyle()
        super.init(coder: aDecoder)
        configViews()
    }
    
    // MARK: - Methods
    
    fileprivate func configViews() {
        segmentedControl.tintColor = style.segmentControlTintColor
        if #available(iOS 13.0, *) {
            segmentedControl.selectedSegmentTintColor = style.selectedSegmentTintColor
        }
        dateIntervalLabel.font = style.fontDateInterval
        menuView.backgroundColor = style.bgColor
        todayButton.tintColor = style.buttonTintColor
        todayButton.layer.borderColor = style.buttonBorderColor.cgColor
        doneButton.tintColor = style.buttonTintColor
        doneButton.layer.borderColor = style.buttonBorderColor.cgColor
        
        blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        segmentedControl.addTarget(self, action: #selector(handleSegmentChanges), for: .valueChanged)
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        monthYearPicker.addTarget(self, action: #selector(monthChanged), for: .valueChanged)
        weeksPicker.addTarget(self, action: #selector(weekChanged), for: .valueChanged)
        doneButton.addTarget(self, action: #selector(buttonOKPressed), for: .touchUpInside)
        todayButton.addTarget(self, action: #selector(buttonTodayPressed), for: .touchUpInside)
        
        blackView.addSubview(menuView)
        
        menuView.addSubview(dateIntervalLabel)
        
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                dateIntervalLabel.topAnchor.constraint(equalTo: menuView.safeAreaLayoutGuide.topAnchor),
                dateIntervalLabel.leftAnchor.constraint(equalTo: menuView.safeAreaLayoutGuide.leftAnchor, constant: 10),
                dateIntervalLabel.rightAnchor.constraint(equalTo: menuView.safeAreaLayoutGuide.rightAnchor, constant: -10),
                dateIntervalLabel.heightAnchor.constraint(equalToConstant: 25),
            ])
        } else {
            menuView.addConstraint(NSLayoutConstraint(item: dateIntervalLabel, attribute: .top, relatedBy: .equal, toItem: menuView, attribute: .top, multiplier: 1.0, constant: 3))
            menuView.addConstraint(NSLayoutConstraint(item: dateIntervalLabel, attribute: .left, relatedBy: .equal, toItem: menuView, attribute: .left, multiplier: 1.0, constant: 10))
            menuView.addConstraint(NSLayoutConstraint(item: dateIntervalLabel, attribute: .right, relatedBy: .equal, toItem: menuView, attribute: .right, multiplier: 1.0, constant: -10))
            menuView.addConstraint(NSLayoutConstraint(item: dateIntervalLabel, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .height, multiplier: 1.0, constant: 25))
        }
        
        menuView.addSubview(segmentedControl)
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                segmentedControl.topAnchor.constraint(equalTo: dateIntervalLabel.bottomAnchor, constant: 3),
                segmentedControl.leftAnchor.constraint(equalTo: menuView.safeAreaLayoutGuide.leftAnchor, constant: 10),
                segmentedControl.rightAnchor.constraint(equalTo: menuView.safeAreaLayoutGuide.rightAnchor, constant: -10),
                segmentedControl.heightAnchor.constraint(equalToConstant: 25),
            ])
        } else {
            menuView.addConstraint(NSLayoutConstraint(item: segmentedControl, attribute: .top, relatedBy: .equal, toItem: dateIntervalLabel, attribute: .bottom, multiplier: 1.0, constant: 3))
            menuView.addConstraint(NSLayoutConstraint(item: segmentedControl, attribute: .left, relatedBy: .equal, toItem: menuView, attribute: .left, multiplier: 1.0, constant: 10))
            menuView.addConstraint(NSLayoutConstraint(item: segmentedControl, attribute: .right, relatedBy: .equal, toItem: menuView, attribute: .right, multiplier: 1.0, constant: -10))
            menuView.addConstraint(NSLayoutConstraint(item: segmentedControl, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .height, multiplier: 1.0, constant: 25))
        }
        
        menuView.addSubview(containerPickerView)
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                containerPickerView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 3),
                containerPickerView.leftAnchor.constraint(equalTo: menuView.safeAreaLayoutGuide.leftAnchor, constant: 10),
                containerPickerView.rightAnchor.constraint(equalTo: menuView.safeAreaLayoutGuide.rightAnchor, constant: -10),
                containerPickerView.heightAnchor.constraint(equalToConstant: 90),
            ])
        } else {
            menuView.addConstraint(NSLayoutConstraint(item: containerPickerView, attribute: .top, relatedBy: .equal, toItem: segmentedControl, attribute: .bottom, multiplier: 1.0, constant: 3))
            menuView.addConstraint(NSLayoutConstraint(item: containerPickerView, attribute: .left, relatedBy: .equal, toItem: menuView, attribute: .left, multiplier: 1.0, constant: 10))
            menuView.addConstraint(NSLayoutConstraint(item: containerPickerView, attribute: .right, relatedBy: .equal, toItem: menuView, attribute: .right, multiplier: 1.0, constant: -10))
            menuView.addConstraint(NSLayoutConstraint(item: containerPickerView, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .height, multiplier: 1.0, constant: 90))
        }
        
        menuView.addSubview(doneButton)
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                doneButton.topAnchor.constraint(equalTo: containerPickerView.bottomAnchor, constant: 3),
                doneButton.leftAnchor.constraint(equalTo: menuView.safeAreaLayoutGuide.leftAnchor, constant: UIScreen.main.bounds.size.width / 2),
                doneButton.rightAnchor.constraint(equalTo: menuView.safeAreaLayoutGuide.rightAnchor, constant: -10),
            ])
        } else {
            menuView.addConstraint(NSLayoutConstraint(item: doneButton, attribute: .top, relatedBy: .equal, toItem: containerPickerView, attribute: .bottom, multiplier: 1.0, constant: 3))
            menuView.addConstraint(NSLayoutConstraint(item: doneButton, attribute: .left, relatedBy: .equal, toItem: menuView, attribute: .left, multiplier: 1.0, constant: UIScreen.main.bounds.size.width / 2))
            menuView.addConstraint(NSLayoutConstraint(item: doneButton, attribute: .right, relatedBy: .equal, toItem: menuView, attribute: .right, multiplier: 1.0, constant: -10))
        }
        
        menuView.addSubview(todayButton)
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                todayButton.topAnchor.constraint(equalTo: containerPickerView.bottomAnchor, constant: 3),
                todayButton.leftAnchor.constraint(equalTo: menuView.safeAreaLayoutGuide.leftAnchor, constant: 10),
                todayButton.rightAnchor.constraint(equalTo: doneButton.leftAnchor, constant: -10),
            ])
        } else {
            menuView.addConstraint(NSLayoutConstraint(item: todayButton, attribute: .top, relatedBy: .equal, toItem: containerPickerView, attribute: .bottom, multiplier: 1.0, constant: 3))
            menuView.addConstraint(NSLayoutConstraint(item: todayButton, attribute: .left, relatedBy: .equal, toItem: menuView, attribute: .left, multiplier: 1.0, constant: 10))
            menuView.addConstraint(NSLayoutConstraint(item: todayButton, attribute: .right, relatedBy: .equal, toItem: menuView, attribute: .right, multiplier: 1.0, constant: -10))
        }
    }
    
    open func showCalendarMenu() {
        let keyWindow: UIWindow?
        
        if #available(iOS 13.0, *) {
            keyWindow = UIApplication.shared.connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .map { $0 as? UIWindowScene }
                .compactMap { $0 }
                .first?.windows
                .filter { $0.isKeyWindow }.first
        } else {
            keyWindow = UIApplication.shared.keyWindow
        }
        
        if let window = keyWindow {
            window.addSubview(blackView)
            
            let height: CGFloat = 230
            let y = window.frame.height - height
            menuView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            blackView.frame = window.frame
            blackView.alpha = 0
            
            configDateView()
            
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 1,
                           options: .curveEaseOut,
                           animations: {
                               self.blackView.alpha = 1
                               self.menuView.alpha = 1
                               
                               self.menuView.frame = CGRect(x: 0, y: y, width: self.menuView.frame.width, height: self.menuView.frame.height)
                           }, completion:
                           nil)
        }
    }
    
    func configDateView() {
        if segmentedControl.selectedSegmentIndex == 0 {
            dateIntervalLabel.text = CalendarFormatter.dateFormatter.string(from: dayOfCalendar ?? Date())
            containerPickerView.addSubview(datePicker)
            
            if #available(iOS 9.0, *) {
                datePicker.centerXAnchor.constraint(equalTo: menuView.centerXAnchor).isActive = true
                datePicker.topAnchor.constraint(equalTo: containerPickerView.topAnchor).isActive = true
                datePicker.leftAnchor.constraint(equalTo: containerPickerView.leftAnchor).isActive = true
                datePicker.bottomAnchor.constraint(equalTo: containerPickerView.bottomAnchor).isActive = true
            }
            
        } else if segmentedControl.selectedSegmentIndex == 1 {
            if let firstDay = firstDayOfCalendar, let lastDay = lastDayOfCalendar {
                dateIntervalLabel.text = CalendarFormatter.weekDateFormatter.string(from: firstDay) + " - " + CalendarFormatter.weekDateFormatter.string(from: lastDay)
            } else {
                let monday = Date().startOfWeek!
                dateIntervalLabel.text = CalendarFormatter.weekDateFormatter.string(from: monday) + " - " + CalendarFormatter.weekDateFormatter.string(from: CalendarFormatter.addWeeks(weeks: 1, to: monday, isForward: true))
            }
            containerPickerView.addSubview(weeksPicker)
            if #available(iOS 9.0, *) {
                weeksPicker.centerXAnchor.constraint(equalTo: menuView.centerXAnchor).isActive = true
                weeksPicker.topAnchor.constraint(equalTo: containerPickerView.topAnchor).isActive = true
                weeksPicker.leftAnchor.constraint(equalTo: containerPickerView.leftAnchor).isActive = true
                weeksPicker.bottomAnchor.constraint(equalTo: containerPickerView.bottomAnchor).isActive = true
            }
        } else {
            dateIntervalLabel.text = CalendarFormatter.monthDateFormatter.string(from: monthOfCalendar ?? Date())
            containerPickerView.addSubview(monthYearPicker)
            if #available(iOS 9.0, *) {
                monthYearPicker.centerXAnchor.constraint(equalTo: menuView.centerXAnchor).isActive = true
                monthYearPicker.topAnchor.constraint(equalTo: containerPickerView.topAnchor).isActive = true
                monthYearPicker.leftAnchor.constraint(equalTo: containerPickerView.leftAnchor).isActive = true
                monthYearPicker.bottomAnchor.constraint(equalTo: containerPickerView.bottomAnchor).isActive = true
            }
        }
    }
    
    // MARK: - Objc methods
    
    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            let keyWindow: UIWindow?
            
            if #available(iOS 13.0, *) {
                keyWindow = UIApplication.shared.connectedScenes
                    .filter { $0.activationState == .foregroundActive }
                    .map { $0 as? UIWindowScene }
                    .compactMap { $0 }
                    .first?.windows
                    .filter { $0.isKeyWindow }.first
            } else {
                keyWindow = UIApplication.shared.keyWindow
            }
            
            if let window = keyWindow {
                self.menuView.frame = CGRect(x: 0, y: window.frame.height, width: self.menuView.frame.width, height: self.menuView.frame.height)
            }
        }
    }
    
    @objc func dateChanged() {
        dayOfCalendar = datePicker.date
        monthOfCalendar = dayOfCalendar?.startOfMonth
        firstDayOfCalendar = dayOfCalendar?.startOfWeek
        lastDayOfCalendar = CalendarFormatter.addWeeks(weeks: 1, to: firstDayOfCalendar!, isForward: true)
    }
    
    @objc func monthChanged() {
        dayOfCalendar = monthYearPicker.date
        monthOfCalendar = monthYearPicker.date
        firstDayOfCalendar = monthOfCalendar?.startOfWeek
        lastDayOfCalendar = CalendarFormatter.addWeeks(weeks: 1, to: firstDayOfCalendar!, isForward: true)
    }
    
    @objc func weekChanged() {
        dayOfCalendar = weeksPicker.firstDay
        monthOfCalendar = weeksPicker.firstDay.startOfMonth
        firstDayOfCalendar = weeksPicker.firstDay
        lastDayOfCalendar = weeksPicker.lastDay
    }
    
    @objc fileprivate func handleSegmentChanges() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            datePicker.isHidden = false
            weeksPicker.isHidden = true
            monthYearPicker.isHidden = true
            calendarInterval = .Day
        case 1:
            datePicker.isHidden = true
            weeksPicker.isHidden = false
            monthYearPicker.isHidden = true
            calendarInterval = .Week
        case 2:
            datePicker.isHidden = true
            weeksPicker.isHidden = true
            monthYearPicker.isHidden = false
            calendarInterval = .Month
        default:
            break
        }
        configDateView()
    }
    
    @objc fileprivate func buttonTodayPressed() {
        segmentedControl.selectedSegmentIndex = 0
        datePicker.isHidden = false
        weeksPicker.isHidden = true
        monthYearPicker.isHidden = true
        calendarInterval = .Day
        
        datePicker.date = Date()
        dayOfCalendar = datePicker.date
        monthOfCalendar = dayOfCalendar?.startOfMonth
        firstDayOfCalendar = dayOfCalendar?.startOfWeek
        lastDayOfCalendar = CalendarFormatter.addWeeks(weeks: 1, to: firstDayOfCalendar!, isForward: true)
    }
    
    @objc fileprivate func buttonOKPressed() {
        if segmentedControl.selectedSegmentIndex == 0 {
            dateIntervalLabel.text = CalendarFormatter.dateFormatter.string(from: dayOfCalendar ?? Date())
        } else if segmentedControl.selectedSegmentIndex == 1 {
            if let firstDay = firstDayOfCalendar, let lastDay = lastDayOfCalendar {
                dateIntervalLabel.text = CalendarFormatter.weekDateFormatter.string(from: firstDay) + " - " + CalendarFormatter.weekDateFormatter.string(from: lastDay)
            } else {
                let monday = Date().startOfWeek!
                dateIntervalLabel.text = CalendarFormatter.weekDateFormatter.string(from: monday) + " - " + CalendarFormatter.weekDateFormatter.string(from: CalendarFormatter.addWeeks(weeks: 1, to: monday, isForward: true))
            }
        } else {
            dateIntervalLabel.text = CalendarFormatter.monthDateFormatter.string(from: monthOfCalendar ?? Date())
        }
        sendActions(for: .valueChanged)
        handleDismiss()
    }
}
