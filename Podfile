platform :ios, '11.0'
inhibit_all_warnings!
source 'https://github.com/CocoaPods/Specs.git'


# -------------------------------------------------- #
def vendor
  #  pod 'web3.swift.pod', '~> 2.2.1'

    # Fix release build problem
    pod 'Web3swift.pod', git: 'https://github.com/matter-labs/web3swift', branch: 'master'
    
    pod 'KeychainAccess'
    pod 'SPStorkController', git: 'https://github.com/lmcmz/SPStorkController', branch: 'master'
    pod 'SPLarkController'
    pod 'IQKeyboardManagerSwift'
    pod 'HandyJSON', '~> 5.0.3-beta'
#    pod 'HandyJSON', git: 'https://github.com/alibaba/HandyJSON.git' , branch: 'dev_for_swift5.0'
    pod 'Moya', '~> 13.0'
    pod 'SwiftEntryKit', '1.2.3'
    pod 'MarqueeLabel'
    pod 'Hero'
    pod 'Kingfisher'
    pod 'WalletConnectSwift', git: 'https://github.com/WalletConnect/WalletConnectSwift', branch: 'master'
    pod 'HanekeSwift',  git: 'https://github.com/Haneke/HanekeSwift', branch: 'master'
    pod 'BonMot'
    pod 'SwiftyUserDefaults',  git: 'https://github.com/sunshinejr/SwiftyUserDefaults', branch: 'master'
    pod 'TrustWalletCore'
    pod 'VBFPopFlatButton'
    pod "ViewAnimator"
  #  pod 'SVGKit'
  #  pod 'RxSwift', '~> 5'
  #  pod 'RxCocoa', '~> 5'
  #  pod 'lottie-ios'
    pod "ESPullToRefresh"
    pod 'JXSegmentedView', git: 'https://github.com/pujiaxin33/JXSegmentedView', branch: 'master'
    pod 'FoldingCell'
    pod 'Pageboy', '~> 3.5.0'
  #  pod 'AwaitKit'
    pod 'Instructions', '~> 1.4.0'
    pod "SkeletonView"
    pod 'SwiftDate', '~> 5.0'
end


# -------------------------------------------------- #
def chat
  pod 'Chatto', '= 3.5.0'
  pod 'ChattoAdditions', '= 3.5.0'
  pod 'SwiftMatrixSDK'
end


# -------------------------------------------------- #
def remote
  #for push notifications
  pod 'Fabric'
  pod 'Crashlytics'
  pod 'Firebase/Core'
  pod 'Firebase/Messaging'
  pod 'Firebase/Analytics'
  pod 'Firebase/Performance'
end


# -------------------------------------------------- #
def rn
  # React Native Dependencies
    pod 'React', :path => '../node_modules/react-native', :subspecs => [
    'Core',
    'CxxBridge',
    'DevSupport',
    'RCTText',
#    'RCTGeolocation',
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
    pod 'RNSVG', :path => '../node_modules/react-native-svg'
    pod 'RNReactNativeHapticFeedback', :path => '../node_modules/react-native-haptic-feedback'
    pod 'CodePush', :path => '../node_modules/react-native-code-push'
    pod 'react-native-video/VideoCaching', :path => '../node_modules/react-native-video/react-native-video.podspec'
    pod 'RNFirebase', :path => '../node_modules/react-native-firebase/ios'
    pod 'ReactNativeExceptionHandler', :podspec => '../node_modules/react-native-exception-handler/ReactNativeExceptionHandler.podspec'
    pod 'RNReanimated', :path => '../node_modules/react-native-reanimated'
    pod 'RNScreens', :path => '../node_modules/react-native-screens'

  #  pod 'RNFBApp', :path => '../node_modules/@react-native-firebase/app'
  #  pod 'RNFBMessaging', :path => '../node_modules/@react-native-firebase/messaging'
end


# -------------------------------------------------- #
target 'AliceX' do
  use_frameworks!
  
  vendor
#  chat
  remote
  rn

end

post_install do |installer|
  
  rnfirebase = installer.pods_project.targets.find { |target| target.name == 'RNFirebase' }
  rnfirebase.build_configurations.each do |config|
    config.build_settings['HEADER_SEARCH_PATHS'] = '$(inherited) ${PODS_ROOT}/Headers/Public/**'
  end
  
  installer.pods_project.build_configurations.each do |config|
    config.build_settings.delete('CODE_SIGNING_ALLOWED')
    config.build_settings.delete('CODE_SIGNING_REQUIRED')
  end
  
  installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
          config.build_settings['ENABLE_BITCODE'] = 'YES'
          config.build_settings['SWIFT_VERSION'] = '5.0'
      end
  end
end
