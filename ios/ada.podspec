#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint ada.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'ada'
  s.version          = '0.0.1'
  s.summary          = 'Flutter wrapper for AdaSDK'
  s.description      = 'Flutter plugin bridging AdaSDK APIs'
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }

  s.source_files = 'ada/Sources/ada/**/*.swift'
  s.platform = :ios, '15.0'
  s.vendored_frameworks = 'AdaSdk.xcframework'
  s.static_framework = false

  s.dependency 'Flutter'
  s.dependency 'Google-Mobile-Ads-SDK'
  s.dependency 'GoogleUserMessagingPlatform'

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
