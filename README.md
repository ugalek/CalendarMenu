# CalendarMenu
<p align="left">
<img src="https://img.shields.io/badge/platform-iOS-blue.svg?style=flat" alt="Platform iOS" />
<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/swift5-compatible-4BC51D.svg?style=flat" alt="Swift 5 compatible" /></a>
<a href="https://raw.githubusercontent.com/ugalek/CalendarMenu/master/LICENSE"><img src="http://img.shields.io/badge/license-MIT-blue.svg?style=flat" alt="License: MIT" /></a>
</p>

**Customizable calendar menu for iOS (13.0 or later), written in Swift 5.**

* UIControl subclass for date / week / month selection
* I18n / i10n aware
* Themable

<p align="center">
  <img src="https://github.com/ugalek/CalendarMenu/blob/master/Images/CalendarMenu.gif">
</p>

## Example

Run the example project:

```console
$ git clone git@github.com:ugalek/CalendarMenu.git
$ cd CalendarMenu
$ pod install
```

## Usage

CalendarMenu is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'CalendarMenu'
```

### Integration

Import `CalendarMenu`:

```swift
import CalendarMenu
```

Define a `CalendarMenu` view `IBOutlet` (here, named `cMenu`):

```swift
@IBOutlet weak var cMenu: CalendarMenu!
```

Add a `DateField` object that will handle the target:

```swift
dateField.delegate = self
dateField.addTarget(self, action: #selector(textFieldTapped), for: .touchDown)
```

Then the related `@objc` method that will call the `showCalendarMenu()` method:

```swift
@objc func textFieldTapped() {
    cMenu.showCalendarMenu()
}
```

The selected date can be handled by `.valueChanged` action:

```swift
cMenu.addTarget(self, action: #selector(cMenuValueChanged), for: .valueChanged)

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
```

### Theming

Customizing fonts and colors is as simple as setting a few properties. 

Let's take an example by changing date interval font and button tint color:

```swift
cMenu.style.fontDateInterval = UIFont.systemFont(ofSize: 17.0, weight: .light)
cMenu.style.buttonTintColor = .red
```

| Property  | Description |
| ------------- | ------------- |
| `bgColor`  | View background color  |
| `fontDateInterval`  | Date interval label font |
| `segmentControlTintColor` | Segment control tint color | 
| `selectedSegmentTintColor` | Segment control selected item color |
| `buttonTintColor` | Button tint color |
| `buttonBorderColor` | Button border color |

### Localization

If your project is localized, you can edit `Localizable.strings` to customize strings:

```swift
"Day" = "Jour";
"Week" = "Semaine";
"Month" = "Mois";
"Today" = "Aujourd'hui";
```

## License

CalendarMenu is available under the MIT license. See the LICENSE file for more info.
