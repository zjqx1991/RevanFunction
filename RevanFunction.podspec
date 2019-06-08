#
# Be sure to run `pod lib lint RevanFunction.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RevanFunction'
  s.version          = '0.1.6'
  s.summary          = '封装OC语言功能组件'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
RevanFunction封装OC语言功能组件
                       DESC

  s.homepage         = 'https://github.com/zjqx1991/RevanFunction'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'RevanWang' => 'zjqx1991@163.com' }
  s.source           = { :git => 'https://github.com/zjqx1991/RevanFunction.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'


    #如果在执行pod install 或pod update之前添加 IS_SOURCE=1时加载源码，否则二进制
    #if ENV['IS_SOURCE']
    #源码
    #选项卡
    s.subspec 'RevanSegment' do |segment|
    segment.source_files = 'RevanFunction/Classes/RevanSegment/**/*'
    end
    #下载器
    s.subspec 'RevanDownLoader' do |downLoader|
    downLoader.source_files = 'RevanFunction/Classes/RevanDownLoader/**/*'
    end
    #播放器
    s.subspec 'RevanPlayer' do |player|
    player.source_files = 'RevanFunction/Classes/RevanPlayer/**/*'
    end

    #封装数据库
    s.subspec 'RevanDB' do |revanDB|
    revanDB.source_files = 'RevanFunction/Classes/RevanDB/**/*'
    end

    #消息提示框
    s.subspec 'RevanTipsView' do |tipsView|
    tipsView.source_files = 'RevanFunction/Classes/RevanTipsView/**/*.{h,m}'
    tipsView.resource_bundles = {
    'RevanTipsView' => ['RevanFunction/Classes/RevanTipsView/**/*.xib']
    }
    tipsView.dependency 'SVProgressHUD', '~> 2.2.5'
    tipsView.dependency 'RevanKits/Category'
    end

    #二维码
    s.subspec 'RevanQRCode' do |qrCode|
    qrCode.source_files = 'RevanFunction/Classes/RevanQRCode/**/*.{h,m}'
    qrCode.resource_bundles = {
    'RevanQRCode' => ['RevanFunction/Assets/RevanQRCode/**/*.xcassets', 'RevanFunction/Assets/RevanQRCode/**/*.caf']
    }
    qrCode.dependency 'RevanKits/Category'
    end

    #倒计时
    s.subspec 'RevanCountDown' do |countDown|
    countDown.source_files = 'RevanFunction/Classes/RevanCountDown/**/*.{h,m}'
    end

    #倒计时按钮
    s.subspec 'RevanVerifyButton' do |verifyBtn|
    verifyBtn.source_files = 'RevanFunction/Classes/RevanVerifyButton/**/*.{h,m}'
    verifyBtn.dependency 'RevanFunction/RevanCountDown'
    end

    #截屏
    s.subspec 'RevanSnapshot' do |snapshot|
    snapshot.source_files = 'RevanFunction/Classes/RevanSnapshot/**/*.{h,m}'
    end


    #else
    #二进制
    #选项卡
    #s.subspec 'RevanSegment' do |segment|
    #    segment.source_files = 'RevanFunction/Classes/RevanSegment/**/*.h'
    #    segment.vendored_frameworks = 'RevanFunction/Products/Release-iphonesimulator/RevanSegmentFramework.framework'
    #end
    #下载器
    #s.subspec 'RevanDownLoader' do |downLoader|
    #    downLoader.source_files = 'RevanFunction/Classes/RevanDownLoader/**/*.h'
    #    downLoader.vendored_frameworks = 'RevanFunction/Products/Release-iphonesimulator/RevanDownLoaderFramework.framework'
    #end
    #播放器
    #s.subspec 'RevanPlayer' do |player|
    #    player.source_files = 'RevanFunction/Classes/RevanPlayer/**/*.h'
    #    player.vendored_frameworks = 'RevanFunction/Products/Release-iphonesimulator/RevanPlayerFramework.framework'
    #end

    #封装数据库
    #s.subspec 'RevanDB' do |revanDB|
    #    revanDB.source_files = 'RevanFunction/Classes/RevanDB/**/*.h'
    #    revanDB.vendored_frameworks = 'RevanFunction/Products/Release-iphonesimulator/RevanDBFramework.framework'
    #end
    #end
    # s.resource_bundles = {
    #   'RevanFunction' => ['RevanFunction/Assets/*.png']
    # }

    # s.public_header_files = 'Pod/Classes/**/*.h'
    # s.frameworks = 'UIKit', 'MapKit'
    #s.dependency 'AFNetworking', '~> 2.3'
    #s.dependency 'SDWebImage', '~> 4.0.0'
    #s.dependency 'MJExtension', '~> 3.0.13'
end
