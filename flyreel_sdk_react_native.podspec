require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))
folly_compiler_flags = '-DFOLLY_NO_CONFIG -DFOLLY_MOBILE=1 -DFOLLY_USE_LIBCPP=1 -Wno-comma -Wno-shorten-64-to-32'

Pod::Spec.new do |s|
  # Underscored so the pod name matches its module name; RN 0.87/0.88's spm_dependency
  # rewrites module map paths using the pod name (fixed in 0.89, react/react-native#59182).
  s.name         = "flyreel_sdk_react_native"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.homepage     = package["homepage"]
  s.license      = package["license"]
  s.authors      = package["author"]

  s.platforms    = { :ios => min_ios_version_supported }
  s.source       = { :git => "https://github.com/Flyreel/flyreel-sdk-react-native.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,m,mm,swift}"
  # Manifest for React Native's SwiftPM mode, not a source file
  s.exclude_files = "ios/Package.swift"

  # Flyreel iOS SDK 1.2.3+ is distributed via Swift Package Manager only (not on CocoaPods trunk).
  # Keep in step with ios/Package.swift.
  unless respond_to?(:spm_dependency, true)
    raise "flyreel-sdk-react-native requires React Native 0.75+ (spm_dependency) to resolve the Flyreel iOS SDK via Swift Package Manager."
  end
  spm_dependency(s,
    url: 'https://github.com/Flyreel/flyreel-sdk-ios.git',
    requirement: { kind: 'exactVersion', version: '1.2.3' },
    products: ['Flyreel']
  )

  # Use install_modules_dependencies helper to install the dependencies if React Native version >=0.71.0.
  # See https://github.com/facebook/react-native/blob/febf6b7f33fdb4904669f99d795eba4c0f95d7bf/scripts/cocoapods/new_architecture.rb#L79.
  if respond_to?(:install_modules_dependencies, true)
    install_modules_dependencies(s)
  else
  s.dependency "React-Core"

  # Don't install the dependencies when we run `pod install` in the old architecture.
  if ENV['RCT_NEW_ARCH_ENABLED'] == '1' then
    s.compiler_flags = folly_compiler_flags + " -DRCT_NEW_ARCH_ENABLED=1"
    s.pod_target_xcconfig    = {
        "HEADER_SEARCH_PATHS" => "\"$(PODS_ROOT)/boost\"",
        "OTHER_CPLUSPLUSFLAGS" => "-DFOLLY_NO_CONFIG -DFOLLY_MOBILE=1 -DFOLLY_USE_LIBCPP=1",
        "CLANG_CXX_LANGUAGE_STANDARD" => "c++17"
    }
    s.dependency "React-Codegen"
    s.dependency "RCT-Folly"
    s.dependency "RCTRequired"
    s.dependency "RCTTypeSafety"
    s.dependency "ReactCommon/turbomodule/core"
   end
  end    
end
