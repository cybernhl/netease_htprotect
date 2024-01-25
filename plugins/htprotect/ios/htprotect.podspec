#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint htprotect.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'htprotect'
  s.version          = '0.0.3'
  s.summary          = 'A new Flutter plugin project.'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/HtprotectPlugin.{h,m}'
  s.public_header_files = 'Classes/HtprotectPlugin.h'
  s.dependency 'Flutter'
  s.vendored_frameworks = "Classes/RiskPerception.framework"
  s.resource = "Assets/RiskPerceptionBundle.bundle"
  s.platform = :ios, '9.0'
  s.frameworks = "AdSupport", "AVFoundation", "CoreTelephony", "SystemConfiguration"
  s.libraries = "c++.1"

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
