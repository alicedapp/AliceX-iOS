platform :ios, '13.0'

# -------------------------------------------------- #
def vendor
    # Fix release build problem
    pod 'web3swift', git: 'https://github.com/skywinder/web3swift.git', branch: 'develop'
    
    pod 'KeychainAccess'
    pod 'SPStorkController', git: 'https://github.com/lmcmz/SPStorkController', branch: 'master'
    pod 'SPLarkController'
    pod 'IQKeyboardManagerSwift'
    pod 'HandyJSON', '~> 5.0.2'
    pod 'Moya', '~> 15.0.0'
    pod 'SwiftEntryKit', '2.0.0'
    pod 'MarqueeLabel'
    pod 'Hero'
    pod 'Kingfisher'
    pod 'WalletConnectSwift', git: 'https://github.com/DtechLabs/WalletConnectSwift.git', branch: 'master'
    pod 'HanekeSwift', git: 'https://github.com/Haneke/HanekeSwift.git', branch: 'master'
    pod 'BonMot'
    pod 'SwiftyUserDefaults', '~> 5.0'
    pod 'TrustWalletCore'
    pod 'VBFPopFlatButton'
    pod "ViewAnimator"
    pod "ESPullToRefresh"
    pod 'JXSegmentedView'
    pod 'FoldingCell'
    pod 'Pageboy', '~> 3.6.2'
    pod 'Instructions', '~> 2.1.0'
    pod "SkeletonView"
    pod 'SwiftDate', '~> 6.3.1'
    pod 'MessageKit'
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
  pod 'Firebase/Analytics'
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'Firebase/Storage'
  pod 'Firebase/Performance'
  pod 'Firebase/Messaging'
  pod 'Firebase/Crashlytics'
end


# -------------------------------------------------- #
target 'AliceX' do
  use_frameworks!
  
  vendor
#  chat
  remote

end

post_install do |installer|
  # installer.pods_project.build_configurations.each do |config|
  #   config.build_settings.delete('CODE_SIGNING_ALLOWED')
  #   config.build_settings.delete('CODE_SIGNING_REQUIRED')
  # end
  
  # installer.pods_project.targets.each do |target|
  #     target.build_configurations.each do |config|
  #         config.build_settings['ENABLE_BITCODE'] = 'YES'
  #         config.build_settings['SWIFT_VERSION'] = '5.0'
  #     end
  # end
end
