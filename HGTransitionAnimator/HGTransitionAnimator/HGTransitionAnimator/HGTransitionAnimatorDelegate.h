//
//  HGTransitionAnimatorDelegate.h
//  HGTransitionAnimator
//
//  Created by 查昊 on 16/5/25.
//  Copyright © 2016年 haocha. All rights reserved.
//

#import <UIKit/UIKit.h>
#pragma mark - HGTransitionAnimatorDelegate
@class HGTransitionAnimator;
@protocol HGTransitionAnimatorDelegate <NSObject>
@optional

/**
 *  弹出控制器视图之后后调用该代理方法
 */
- (void)transitionAnimator:(HGTransitionAnimator *)animator animationControllerForPresentedController:(UIViewController *)presented;

/**
 *  回收控制器视图之后调用该代理方法
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
 *
 *  @return 动画时间
 */
- (NSTimeInterval)transitionDuration:(HGTransitionAnimator *)animator;

/**
 *  背景点击是否响应,默认YES
 */
- (BOOL)transitionAnimatorCanResponse:(HGTransitionAnimator *)animator;
@end

#pragma mark - HGPresentationControllerDelegate
@class HGPresentationController;
@protocol HGPresentationControllerDelegate <NSObject>
@optional

/**
 *  点击了蒙版,蒙版即将消失
 *
 *  @param coverView 蒙版View
 *
 *  @return 是否需要动画
 */
- (BOOL)coverViewWillDismiss:(UIView *)coverView;


/**
 *  暂时不用
 */
- (BOOL)presentationControllerCanPanLeftOrRight:(HGPresentationController *)controller;
- (BOOL)presentationControllerCanPanTopOrBottom:(HGPresentationController *)controller;
@end









