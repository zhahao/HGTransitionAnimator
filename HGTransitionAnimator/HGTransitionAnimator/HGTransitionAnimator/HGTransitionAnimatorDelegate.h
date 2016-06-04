//
//  HGTransitionAnimatorDelegate.h
//  HGTransitionAnimator
//
//  Created by 查昊 on 16/5/25.
//  Copyright © 2016年 haocha. All rights reserved.
//  github地址:https://github.com/zhahao/HGTransitionAnimator

#import <UIKit/UIKit.h>
#pragma mark - HGTransitionAnimatorDelegate,在`PresentingViewController`中使用
@class HGTransitionAnimator;
@protocol HGTransitionAnimatorDelegate <NSObject>
@optional

/**
 *  弹出控制器视图之后后调用该代理方法
 *  @param presented   被弹出的控制器
 */
- (void)transitionAnimator:(HGTransitionAnimator *)animator animationControllerForPresentedController:(UIViewController *)presented;

/**
 *  回收控制器视图之后调用该代理方法
 *  @param dismissed   被弹出的控制器
 */
- (void)transitionAnimator:(HGTransitionAnimator *)animator animationControllerForDismissedController:(UIViewController *)dismissed;

/**
 *  自定义动画需要用到,在该代理方法中实现动画效果
 *
 *  @param toView   即将显示的控制器视图
 *  @param duration 动画时间
 */
- (void)transitionAnimator:(HGTransitionAnimator *)animator animateTransitionToView:(UIView *)toView duration:(NSTimeInterval)duration;

/**
 *  自定义动画需要用到,在该代理方法中实现动画效果
 *
 *  @param toView   即将消失的控制器视图
 *  @param duration 动画时间
 */
- (void)transitionAnimator:(HGTransitionAnimator *)animator animateTransitionFromView:(UIView *)fromView duration:(NSTimeInterval)duration;

/**
 *  设置动画时间
 *  注意:如果在构造函数里面设置了animated=NO, 避免实现该代理
 *  @return 动画时间
 */
- (NSTimeInterval)transitionDuration:(HGTransitionAnimator *)animator;

/**
 *  背景点击是否响应,默认YES
 */
- (BOOL)transitionAnimatorCanResponse:(HGTransitionAnimator *)animator;
@end

#pragma mark - HGPresentationControllerDelegate,在`PresentedViewController`中使用
@class HGPresentationController;
@protocol HGPresentationControllerDelegate <NSObject>

@optional
/**
 *  `蒙版`和`PresentedView`即将消失.
 *  在`PresentedViewController`设置是否需要消失动画,可以在该代理中做一些其他的操作.
 *  @param duration 即将消失花费的时间
 *
 *  @return 是否动画,默认YES。
 */
- (BOOL)presentedViewBeginDismiss:(NSTimeInterval)duration;

@end









