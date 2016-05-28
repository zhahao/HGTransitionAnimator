HGPopverAnimator
==============
如何使用
==============
###导入头文件
	#import "UIViewController+HGPopver.h"

###Present方法
```
OneViewController *oneVC=[[OneViewController alloc]init];
	[self hg_presentViewController:oneVC animateStyle:HGPopverAnimatorFromLeftStyle  delegate:self presentFrame:_presentFrame backgroundColor:_backgroundColor animated:YES];
```

###Dismiss方法
```
[self hg_dismissViewControllerAnimated:YES completion:nil];
```
###自定义需要做的:
```
实现HGPopverAnimatorDelegate代理方法
@interface ViewController ()	<HGPopverAnimatorDelegate>
- (void)popverAnimateTransitionToView:(UIView *)toView duration:(NSTimeInterval)duration
{
	// 弹出动画代码写在这里
}
- (void)popverAnimateTransitionFromView:(UIView *)fromView duration:(NSTimeInterval)duration
{
	// 消失动画代码写在这里
}
- (NSTimeInterval)popverTransitionDuration
{
    // 动画时间写在这里
}
// 更多代理方法详见demo
```
#项目演示
`查看并运行 	HGPopverAnimator/demo`
##自定义样式
```
	animateStyle:HGPopverAnimatorCustomStyle
```
![(自定义样式)](http://files.cnblogs.com/files/zhahao/%E8%87%AA%E5%AE%9A%E4%B9%89%E6%A0%B7%E5%BC%8F.gif)
##底部弹出样式
```
	animateStyle:HGPopverAnimatorFromBottomStyle
```
![(底部弹出)](http://files.cnblogs.com/files/zhahao/%E5%BA%95%E9%83%A8%E5%BC%B9%E5%87%BA.gif)
##隐藏样式
```
	animateStyle:HGPopverAnimatorHiddenStyle
```
![(隐藏样式)](http://files.cnblogs.com/files/zhahao/%E9%9A%90%E8%97%8F%E6%A0%B7%E5%BC%8F.gif)
##垂直压缩样式
```
	animateStyle:HGPopverAnimatorVerticalScaleStyle
```
![(垂直压缩)](http://files.cnblogs.com/files/zhahao/%E5%9E%82%E7%9B%B4%E5%8E%8B%E7%BC%A9%E6%A0%B7%E5%BC%8F.gif)
系统要求
==============
该项目最低支持 `iOS 7.0` 和 `Xcode 7.0`。


注意
==============
Present和Dismiss只需要分别调用一句代码,Present出来的一定是控制器。可以不必像demo那样弹出这样大的视图,例如`QQ右上角的添加`,`分享界面的底部弹出`都可以用自带样式。共有`10`种自带的样式,基本上可以满足日常的开发需求。如果自定义,请实现`HGPopverAnimatorDelegate`代理方法。


许可证
==============
HGPopverAnimator 使用 MIT 许可证，详情见 LICENSE 文件。