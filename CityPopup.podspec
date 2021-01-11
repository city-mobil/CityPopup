Pod::Spec.new do |spec|

  spec.name                   = "CityPopup"
  spec.version                = "0.1"
  spec.summary                = "A popup display engine framework for iOS and iPadOS."
  spec.description            = <<-DESC
  CityPopup is a framework for iOS and iPadOS that is a popup display engine written in Swift.
  We at Citymobil have developed the logic that is used in our project and decided that it can help not only us.
  It takes care of all necessary logic to display views within your app easily.
  This framework is suitable both for those who just need to show some information, and for those who want to implement non-standard animation along with a complex view, as it is highly customizable.
  DESC
  spec.homepage               = "https://github.com/city-mobil/CityPopup"
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
  spec.framework              = "UIKit"
  spec.requires_arc           = true

  spec.default_subspec = "Core"

  spec.subspec "Core" do |core|
    core.source_files = "CityPopup/Core/**/*.{swift}"
  end

  spec.subspec "Toast" do |toast|
    toast.source_files = "CityPopup/Toast/**/*.{swift}"
    toast.dependency "CityPopup/Core"
  end

  spec.subspec "Alert" do |alert|
    alert.source_files = "CityPopup/Alert/**/*.{swift}"
    alert.dependency "CityPopup/Core"
  end

end
