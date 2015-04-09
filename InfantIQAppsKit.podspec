#
# Be sure to run `pod lib lint InfantIQAppsKit.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "InfantIQAppsKit"
  s.version          = "0.1.0"
  s.summary          = "Kit for showing other InfantIQAppsKit."
  s.homepage         = "https://github.com/npahucki/InfantIQAppsKit"
  s.license          = 'Copyright'
  s.author           = { "Nathan Pahucki" => "npahucki@gmail.com" }
  s.source           = { :git => "https://github.com/npahucki/InfantIQAppsKit.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'InfantIQAppsKit' => ['Pod/Assets/*']
  }

  s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
