//
//  HGPresentationController.h
//  HGTransitionAnimator
//
//  Created by 查昊 on 16/5/23.
//  Copyright © 2016年 haocha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGTransitionAnimatorDelegate.h"
#import "HGTransitionAnimator.h"
/**
 *  拖拽方向
 */
typedef NS_OPTIONS(NSUInteger, HGPresentationfDragDirection) {
    HGPresentationfDragDirectionRight      =0,  //向右
    HGPresentationfDragDirectionLeft       =1,  //向左
    HGPresentationfDragDirectionUp         =2,  //向上
    HGPresentationfDragDirectionDown       =3   //向下
};

NS_ASSUME_NONNULL_BEGIN
@interface HGPresentationController : UIPresentationController
/// 代理
@property (nonatomic, assign,nonnull)id <HGPresentationControllerDelegate>  hg_delegate;
/// 拖拽方向
@property (nonatomic, assign)HGPresentationfDragDirection direction;

/**
 *  初始化方法
 *
 *  @param presentedViewController  被转场的控制器
 *  @param presentingViewController 负责转场的控制器
 *  @param animateStyle             转场动画类型
 *  @param presentFrame             被转场控制器的视图frame
 *  @param backgroundColor          蒙版背景颜色
 *  @param duration                 动画时间
 *  @param response                 蒙版是否响应点击时间
 *
 *  @return HGPresentationController
 */
- (instancetype )initWithPresentedViewController:(nonnull UIViewController *)presentedViewController
                        presentingViewController:(nonnull UIViewController *)presentingViewController
                                 backgroundColor:(nonnull UIColor *)backgroundColor
                                    animateStyle:(HGTransitionAnimatorStyle)animateStyle
                                    presentFrame:(CGRect)presentFrame
                                        duration:(NSTimeInterval )duration
                                        response:(BOOL)response;

@end
NS_ASSUME_NONNULL_END