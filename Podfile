platform :ios, '10.0'
inhibit_all_warnings!
source 'https://github.com/CocoaPods/Specs.git'
plugin 'cocoapods-binary'

target 'AliceX' do
  use_frameworks!
  keep_source_code_for_prebuilt_frameworks!
  enable_bitcode_for_prebuilt_frameworks!

  pod 'web3.swift.pod', '~> 2.2.1' , :binary => true
  pod 'KeychainAccess'
  pod 'SPStorkController'
  pod 'IQKeyboardManagerSwift'
  pod 'HandyJSON', '~> 5.0.0'
  pod 'Moya', '~> 13.0'
  pod 'fluid-slider'
  pod 'SwiftEntryKit', '1.0.2'
  pod 'MarqueeLabel'
  pod 'Hero'
#  pod 'lottie-ios'

#   React Native Dependencies
  pod 'React', :path => '../node_modules/react-native', :subspecs => [
  'Core',
  'CxxBridge',
  'DevSupport',
  'RCTText',
  'RCTGeolocation',
  'RCTAnimation',
  'RCTImage',
  'RCTActionSheet',
  'RCTNetwork',
  'RCTWebSocket',
  'RCTLinkingIOS'
  ]

  pod 'Folly', :podspec => '../node_modules/react-native/third-party-podspecs/Folly.podspec'
  pod 'yoga', :path => '../node_modules/react-native/ReactCommon/yoga'
  pod 'RNGestureHandler', :path => '../node_modules/react-native-gesture-handler'
  pod 'react-native-camera', path: '../node_modules/react-native-camera'
  pod 'react-native-mapbox-gl', :path => '../node_modules/@mapbox/react-native-mapbox-gl'
  pod 'react-native-onesignal',
  :path => "../node_modules/react-native-onesignal/react-native-onesignal.podspec",
  :inhibit_warnings => true
end
