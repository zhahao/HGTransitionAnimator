//
//  HGTransitioningDelegate.h
//  自定义转场动画_OC
//
//  Created by 查昊 on 16/5/23.
//  Copyright © 2016年 haocha. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,HGPopverAnimatorStyle)
{
    HGPopverAnimatorCustomStyle=0,          //自定义样式
    HGPopverAnimatorFromLeftStyle,          //从左边弹出样式
    HGPopverAnimatorFromRightStyle,         //从右边弹出样式
    HGPopverAnimatorFromTopStyle,           //从顶部弹出样式
    HGPopverAnimatorFromBottomStyle,        //从底部弹出样式
    HGPopverAnimatorVerticalScaleStyle,     //垂直压缩样式
    HGPopverAnimatorHorizontalScaleStyle,   //水平压缩样式

};

typedef void (^toViewAnimateBlcok)(UIView * toView,NSTimeInterval duration);
typedef void (^fromViewAnimateBlcok)(UIView * fromView,NSTimeInterval duration);
typedef void (^complatedBlcok)();

@interface HGPopverAnimator : NSObject<UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) CGRect presentFrame;//<- 弹出视图的的frame
@property (nonatomic, assign) HGPopverAnimatorStyle animateStyle;//<- push样式

@property (nonatomic, assign) NSTimeInterval duration;//<- 动画时间 deflaut=0.25s
@property (nonatomic, assign) NSTimeInterval pushDuration;//<- push动画时间 deflaut=0.25s
@property (nonatomic, assign) NSTimeInterval popDuration;//<- pop动画时间 deflaut=0.25s
@property (nonatomic, strong) UIColor *backgroundColor;//<- 蒙版背景色
/// 如果是使用了非自定义样式需要完成之后回调,请用该方法
- (void)animatorWithShowComplated:(complatedBlcok)showComplated dismissComplated:(complatedBlcok)dismissComplated;

///////////////////////////--设置了默认样式就不需要再自己实现下面两个方法--////////////////////////

/// 实现自定义弹出动画
- (void)setToViewAnimateTransition:(toViewAnimateBlcok)toViewAnimateBlcok showComplated:(complatedBlcok)complated;
/// 实现自定义消失动画
- (void)setFromViewAnimateTransition:(fromViewAnimateBlcok)fromViewAnimateBlcok dismissComplated:(complatedBlcok)complated;

@end
