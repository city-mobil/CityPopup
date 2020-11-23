#
#  Be sure to run `pod spec lint CityPopup.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name                   = "CityPopup"
  spec.version                = "0.1"
  spec.summary                = "CityPopup is a framework for iOS and iPadOS that is a popup display engine."

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  spec.description            = <<-DESC
  Some description will be here soon...
  DESC
  spec.homepage               = "https://github.com/city-mobil/CityPopup"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See https://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  spec.license                = "MIT (example)"
  spec.license                = { :type => "MIT", :file => "LICENSE" }
  spec.author                 = {
    "Pavel Chilimov" => "chilimovpasha@gmail.com",
    "Georgiy Sabanov" => "georgi.sabano@yandex.ru",
    "Stanislav Svorovsky" => "svorovsky@ya.ru"
  }
  spec.platform               = :ios
  spec.ios.deployment_target  = "9.0"
  spec.swift_version          = "5.3"
  spec.source                 = { :git => "https://github.com/city-mobil/CityPopup.git", :tag => spec.version.to_s }

  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  spec.source_files  = "CityPopup/**/*.{swift}"
  # spec.exclude_files = "Classes/Exclude"
  # spec.public_header_files = "Classes/**/*.h"

  spec.framework  = "UIKit"

  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  spec.requires_arc = true

  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # spec.dependency "JSONKit", "~> 1.4"

end
