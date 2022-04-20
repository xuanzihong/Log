#
# Be sure to run `pod lib lint Log.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Log'
  s.version          = '0.1.0'
  # 描述
  s.summary          = '打印日志Log.'
  # 详细描述
  s.description      = <<-DESC
                        'Swift 打印日志Log'
                       DESC
  # 仓库地址
  s.homepage         = 'https://github.com/xuanzihong/Log'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'xuanzihong' => 'xuanzihong@126.com' }
  s.source           = { :git => 'git@github.com:xuanzihong/Log.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'Log/Classes/**/*'
  
  # s.resource_bundles = {
  #   'Log' => ['Log/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
