platform :ios, '10.0'
inhibit_all_warnings!
source 'https://github.com/CocoaPods/Specs.git'

target 'AliceX' do
  use_frameworks!

#  pod 'web3.swift.pod', '~> 2.2.1'

  # Fix release build problem
  pod 'Web3swift.pod', git: 'https://github.com/matter-labs/web3swift', branch: 'master'
  
  pod 'KeychainAccess'
  pod 'SPStorkController'
  pod 'IQKeyboardManagerSwift'
  pod 'HandyJSON', '~> 5.0.0'
  pod 'Moya', '~> 13.0'
  pod 'SwiftEntryKit', '1.0.2'
  pod 'MarqueeLabel'
  pod 'Hero'
  pod 'Kingfisher'
  pod 'WalletConnect', git: 'https://github.com/alicedapp/swift-walletconnect-lib', branch: 'master'
#  pod 'lottie-ios'
  pod 'HanekeSwift',  git: 'https://github.com/Haneke/HanekeSwift', branch: 'master'

# React Native Dependencies
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
  pod 'react-native-mapbox-gl', :path => '../node_modules/@react-native-mapbox-gl/maps'
  pod 'react-native-onesignal', :git => 'https://github.com/alicedapp/react-native-onesignal', :branch => 'master'
  pod 'RNSVG', :path => '../node_modules/react-native-svg'
  pod 'RNReactNativeHapticFeedback', :path => '../node_modules/react-native-haptic-feedback'
  pod 'CodePush', :path => '../node_modules/react-native-code-push'
  
end

