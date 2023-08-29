Pod::Spec.new do |s|
  s.name         = "HGTransitionAnimator"
  s.version      = "0.1.5"
  s.summary      = "控制器之间的转场动画,内部封装了10+种,只需一句代码即可使"
  s.homepage     = "https://github.com/zhahao/HGTransitionAnimator"
  s.license      = "MIT"
  s.author       = { "zhahao" => "506902638@qq.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/zhahao/HGTransitionAnimator.git", :tag => s.version }
  s.source_files  = "HGTransitionAnimator", "HGTransitionAnimator/HGTransitionAnimator/HGTransitionAnimator/*.{h,m}"
  s.framework  = "UIKit"
end
