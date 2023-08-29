//
//  HGTransitioningDelegate.h
//  HGTransitionAnimator
//
//  Created by 查昊 on 16/5/23.
//  Copyright © 2016年 haocha. All rights reserved.
//  GitHub地址:https://github.com/zhahao/HGTransitionAnimator

#import "HGTransitionAnimatorDelegate.h"


typedef NS_ENUM(NSInteger,HGTransitionAnimatorStyle)
{
    
    HGTransitionAnimatorCustomStyle = 0,        //自定义样式
///////////////参照UIWinow///////////////
    HGTransitionAnimatorFromLeftStyle,          //从左边弹出样式
    HGTransitionAnimatorFromRightStyle,         //从右边弹出样式
    HGTransitionAnimatorFromTopStyle,           //从顶部弹出样式
    HGTransitionAnimatorFromBottomStyle,        //从底部弹出样式
    
///////////////参照PresentView///////////
    HGTransitionAnimatorHiddenStyle,            //显示隐藏样式
    HGTransitionAnimatorVerticalScaleStyle,     //垂直压缩样式
    HGTransitionAnimatorHorizontalScaleStyle,   //水平压缩样式
    HGTransitionAnimatorCenterStyle,            //中点消失样式
    HGTransitionAnimatorFocusTopCenterStyle,    //顶部中点消失样式
    HGTransitionAnimatorFocusTopLeftStyle,      //顶部左上角消失样式
    HGTransitionAnimatorFocusTopRightStyle,     //顶部右上角消失样式
};

/// 默认动画时间
FOUNDATION_EXTERN NSTimeInterval const kHGAnimatorDuration;

NS_ASSUME_NONNULL_BEGIN

NS_CLASS_AVAILABLE_IOS(8_0)  @interface HGTransitionAnimator : NSObject<UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning>

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new  NS_UNAVAILABLE;
/**
 *  构造方法
 *
 *  @param animateStyle    动画类型
 *  @param relateView      参照的view,写`PresentingViewController`的self.view
 *  @param presentFrame    弹出视图的frame
 *  @param backgroundColor 背景色
 *  @param delegate        代理
 *  @param animated        是否动画
 */
- (instancetype)initWithAnimateStyle:(HGTransitionAnimatorStyle)animateStyle
                          relateView:(nonnull UIView *)relateView
                        presentFrame:(CGRect)presentFrame
                     backgroundColor:(nullable UIColor *)backgroundColor
                            delegate:(nullable id <HGTransitionAnimatorDelegate>)delegate
                            animated:(BOOL)animated NS_DESIGNATED_INITIALIZER;


/// 负责转场的对象
@property (nonatomic, strong, nonnull, readonly) HGPresentationController *presentationController;

/**
 *  回调VC生命周期,默认NO
 */
@property(nonatomic, assign) BOOL invokeSourceVCLifeCycleMethods;

/// 发起转场的VC
@property(nonatomic, weak, readonly) UIViewController *sourceViewController;


@end

NS_ASSUME_NONNULL_END




