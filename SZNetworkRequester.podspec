#
# Be sure to run `pod lib lint SZNetworkRequester.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SZNetworkRequester'
  s.version          = '0.1.0'
  s.summary          = '简单封装的网络请求器。'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
对 `AFNetworking` 和 `MJExtension` 进行简单封装的一个网络请求器。
                       DESC

  s.homepage         = 'https://github.com/sunzhuo11/SZNetworkRequester'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Stella' => 'changing_1@126.com' }
  s.source           = { :git => 'https://github.com/sunzhuo11/SZNetworkRequester.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'SZNetworkRequester/Classes/**/*'
  s.resources = 'SZNetworkRequester/Assets/**/*'
  
  # s.resource_bundles = {
  #   'SZNetworkRequester' => ['SZNetworkRequester/Assets/*.png']
  # }

  s.public_header_files = 'SZNetworkRequester/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'AFNetworking'
  s.dependency 'MJExtension'
  s.dependency 'SVProgressHUD'
  s.dependency 'Masonry'
end
