HGTransitionAnimator
==============
如何使用
==============
###导入头文件
	#import "UIViewController+HGAnimator.h"

###Present方法
```
OneViewController *oneVC=[[OneViewController alloc]init];
	[self hg_presentViewController:oneVC animateStyle:HGTransitionAnimatorFromLeftStyle  delegate:self presentFrame:_presentFrame backgroundColor:_backgroundColor animated:YES];
```

###Dismiss方法
```
[self hg_dismissViewControllerAnimated:YES completion:nil];
```
###自定义需要做的:
```
实现HGTransitionAnimatorDelegate代理方法Transition
@interface ViewController ()	<HGTransitionAnimatorDelegate>
- (void)transitionAnimator:(HGTransitionAnimator *)animator animateTransitionToView:(UIView *)toView duration:(NSTimeInterval)duration{	// 弹出动画代码写在这里
}
- (void)transitionAnimator:(HGTransitionAnimator *)animator animateTransitionFromView:(UIView *)fromView duration:(NSTimeInterval)duration
{
	// 消失动画代码写在这里
}
- (NSTimeInterval)transitionDuration:(HGTransitionAnimator *)animator
{
    // 动画时间写在这里
}
- (BOOL)transitionAnimatorCanResponse:(HGTransitionAnimator *)animator
{
	// 蒙版点击是否有效
}
- (NSTimeInterval)transitionDuration:(HGTransitionAnimator *)animator
{
	//修改动画时间
}
// 更多代理方法详见demo
```
#项目演示
`查看并运行 	HGTransitionAnimator/demo`
###自定义样式
```
	animateStyle:HGTransitionAnimatorCustomStyle
```
![(自定义样式)](http://files.cnblogs.com/files/zhahao/%E8%87%AA%E5%AE%9A%E4%B9%89%E6%A0%B7%E5%BC%8F.gif)
###底部弹出样式
```
	animateStyle:HGTransitionAnimatorFromBottomStyle
```
![(底部弹出)](http://files.cnblogs.com/files/zhahao/%E5%BA%95%E9%83%A8%E5%BC%B9%E5%87%BA.gif)
###隐藏样式
```
	animateStyle:HGTransitionAnimatorHiddenStyle
```
![(隐藏样式)](http://files.cnblogs.com/files/zhahao/%E9%9A%90%E8%97%8F%E6%A0%B7%E5%BC%8F.gif)
###垂直压缩样式
```
	animateStyle:HGTransitionAnimatorVerticalScaleStyle
```
![(垂直压缩)](http://files.cnblogs.com/files/zhahao/%E5%9E%82%E7%9B%B4%E5%8E%8B%E7%BC%A9%E6%A0%B7%E5%BC%8F.gif)
系统要求
==============
该项目最低支持 `iOS 7.0` 和 `Xcode 7.0`。


注意
==============
支持`横竖屏的切换`。使用控制器管理弹出视图的好处:`面向协议编程`,使控制器与View之间的传递控制链转换成控制器与控制器之间的传递,降低了代码的耦合度并且提高了代码的复用率,这也是Apple推出转场控制器的用意。如`QQ右上角的添加`、`分享界面的底部弹出`、都可以用自带样式定义一个专属控制器,支持。目前有`11`种自带的样式,基本上可以满足日常的开发需求。如果自定义,请实现`HGTransitionAnimatorDelegate`代理方法。


许可证
==============
HGTransitionAnimator 使用 MIT 许可证，详情见 LICENSE 文件。