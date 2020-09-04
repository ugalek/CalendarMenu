Pod::Spec.new do |s|
  s.name             = 'CalendarMenu'
  s.version          = '0.1.2'
  s.summary          = 'Customizable calendar menu for iOS'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.homepage         = 'https://github.com/ugalek/CalendarMenu'
  s.author           = { 'ugalek' => 'galina@ugalek.com' }
  s.source           = { :git => 'https://github.com/ugalek/CalendarMenu.git', :tag => s.version.to_s }
  s.frameworks = 'UIKit', 'Foundation'
  s.swift_version    = '5.2'
  s.platform     = :ios, '13.4'
  s.source_files = 'Sources/**/*.{h,m,swift}'
end
