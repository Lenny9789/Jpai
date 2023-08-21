# Uncomment the next line to define a global platform for your project
# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/aliyun/aliyun-specs.git'

inhibit_all_warnings!

#post_install do |installer|
#  installer.pods_project.targets.each do |target|
#    target.build_configurations.each do |config|
#      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = "13.0"
#    end
#  end
#end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = "13.0"
    end
    
    shell_script_path = "Pods/Target Support Files/#{target.name}/#{target.name}-frameworks.sh"
    if File::exists?(shell_script_path)
      shell_script_input_lines = File.readlines(shell_script_path)
      shell_script_output_lines = shell_script_input_lines.map { |line| line.sub("source=\"$(readlink \"${source}\")\"", "source=\"$(readlink -f \"${source}\")\"") }
      File.open(shell_script_path, 'w') do |f|
        shell_script_output_lines.each do |line|
          f.write line
        end
      end
    end
  end
end

target 'Jpai' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  pod 'R.swift', '~> 6.0'               #全局图片字体 资源替代
  pod 'RxSwift'               #ReactiveX for Swift
  pod 'RxSwiftExt', '~> 6'
  pod 'RxCocoa'               #UI相关的Rx封装
  pod 'Then'
  pod 'SwifterSwift'
  pod "RxAnimated"
#  pod "ViewAnimator"
  pod 'SwiftDate', '~> 7.0'   #Swift 日期处理库
  pod 'Alamofire'             #Http请求库
  pod 'Cache'                 #缓存库，可将各种对象以key存储到磁盘，同时可以设置存储的失效期
  pod 'Kingfisher', '~> 7.0'    #网络图片请求库
  pod 'DeviceKit'             #值型替代品UIDevice
  pod "ESPullToRefresh"       #下拉刷新
  pod 'SwiftTheme'            #换肤解决方案
  #  pod 'CryptoSwift'           #AES加解密等
  pod "RxGesture"                   #用于视图手势的Rx包装
  pod 'RxKeyboard'                  #响应式的键盘组件
  pod 'WHC_KeyboardManager'
  #  pod 'RxDataSources'               #UITableView和UICollectionView的Rx数据源包装
  pod 'WHC_Layout'                  #动态自动布局库
  pod 'SnapKit'
  pod 'SwiftyUserDefaults', '~> 5.0'
  pod 'SwiftyJSON', '~> 4.0'        #json处理框架
  #  pod 'SexyJson'
  pod 'CleanJSON'
  #  pod 'FunWave'
#  pod 'AliyunOSSiOS'
  #  pod 'AlipaySDK-iOS'
  #  pod 'AlicloudPush', '~> 1.9.9.5'
  #  pod 'WechatOpenSDK-XCFramework'
  #UI组件
#  pod 'PPBadgeViewSwift'
  pod 'FSPagerView'
  pod 'Lantern'                           #图片/视频浏览
  pod 'ZLPhotoBrowser', '~> 4.1.7'        #相册多选框架
  #  pod 'JPImageresizerView', '~> 1.3.4'    #裁剪图片、GIF、视频
  #  pod 'lottie-ios'                        #骨骼动画
  pod 'JXSegmentedView'                   #主流APP分类切换滚动视图
  pod 'JXPagingView/Paging'
  #  pod 'GKPageScrollView/Swift'            #UIScrollview嵌套滑动库
  #  pod 'GKPageSmoothView/Swift'            #UIScrollview嵌套滑动库
  pod 'GKNavigationBarSwift'              #自定义导航栏
  #  pod 'PPBadgeViewSwift'                  #自定义Badge组件, 支持UIView, UITabBarItem, UIBarButtonItem
#  pod 'ActiveLabel'                       #UILabel 替代品，支持 #、@、URL、电子邮件和自定义正则表达式模式
  #  pod 'KDCircularProgress'                #圆形进度条
  pod 'MBProgressHUD', '~> 1.2.0'         #透明指示器
#  pod 'ZFPlayer', '~> 4.0.3'              #列表视频播放器
#  pod 'ZFPlayer/ControlView', '~> 4.0.3'  #列表视频播放器
#  pod 'ZFPlayer/AVPlayer', '~> 4.0.3'     #列表视频播放器
  #  pod 'KTVHTTPCache'                      #视频缓存

  # Pods for Jpai
  pod 'OpenIMSDK'
  
end
