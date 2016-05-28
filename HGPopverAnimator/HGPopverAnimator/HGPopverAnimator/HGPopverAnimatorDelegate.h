//
//  HGPopverAnimatorDelegate.h
//  HGPopverAnimator
//
//  Created by 查昊 on 16/5/25.
//  Copyright © 2016年 haocha. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HGPopverAnimator;
@protocol HGPopverAnimatorDelegate <NSObject>
@optional
/**
 *  弹出控制器视图之后后调用该代理方法
 */
- (void)popverAnimator:(HGPopverAnimator *)animator animationControllerForPresentedController:(UIViewController *)presented;
/**
 *  回收控制器视图之后调用该代理方法
 */
- (void)popverAnimator:(HGPopverAnimator *)animator animationControllerForDismissedController:(UIViewController *)dismissed;

/**
 *  自定义动画需要用到,在该代理方法中实现动画效果
 *
 *  @param toView   即将显示的控制器视图
 *  @param duration 动画时间
 */
- (void)popverAnimator:(HGPopverAnimator *)animator animateTransitionToView:(UIView *)toView duration:(NSTimeInterval)duration;
/**
 *  自定义动画需要用到,在该代理方法中实现动画效果
 *
 *  @param toView   即将消失的控制器视图
 *  @param duration 动画时间
 */
- (void)popverAnimator:(HGPopverAnimator *)animator animateTransitionFromView:(UIView *)fromView duration:(NSTimeInterval)duration;

/**
 *  设置动画时间
 *
 *  @return 动画时间
 */
- (NSTimeInterval)popverAnimatorTransitionDuration:(HGPopverAnimator *)animator;
/**
 *  背景点击是否响应,默认YES
 */
- (BOOL)popverAnimatorBackgoundCanResponse:(HGPopverAnimator *)animator;
@end
