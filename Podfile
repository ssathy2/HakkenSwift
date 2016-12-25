source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target 'Hakken' do
    pod 'CocoaLumberjack/Swift'
    pod 'RealmSwift', '~> 1.0'
    pod 'Alamofire', '~> 4.0'
    pod 'RxSwift', '3.0.0-beta.2'
    pod 'RxCocoa'
    pod 'RxRealm', :git => 'https://github.com/RxSwiftCommunity/RxRealm.git', :branch => 'swift3'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
