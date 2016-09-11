//
//  UIViewController+HGTransition.h
//  HGTransitionAnimator
//
//  Created by 查昊 on 16/5/25.
//  Copyright © 2016年 haocha. All rights reserved.
//  GitHub地址:https://github.com/zhahao/HGTransitionAnimator

#import "HGTransitionAnimator.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *   ⚠️ 该转场动画分类只支持iOS8.0及以上
 */
@interface UIViewController (HGAnimator)

/**
 *  自定义弹出控制器并实现转场动画,一定会在主线程里面执行
 *  用于当前控制器只有`一个`自定义转场代理对象
 *
 *  @param viewControllerToPresent 需要转场出来的控制器
 *  @param style                   转场样式
 *  @param delegate                代理,如果不自定义转场动画,设置为空即可
 *  @param presentFrame            转场控制器的视图frame,相对于window的frame
 *  @param flag                    是否需要动画效果
 *  @return                        转场动画代理对象
 */
- (void)hg_presentViewController:(nonnull UIViewController *)viewControllerToPresent
                    animateStyle:(HGTransitionAnimatorStyle )style
                        delegate:(nullable id <HGTransitionAnimatorDelegate>)delegate
                    presentFrame:(CGRect)presentFrame
                 backgroundColor:(nonnull UIColor *)backgroundColor
                        animated:(BOOL)flag;

/**
 *  自定义弹出控制器并实现转场动画,一定会在主线程里面执行
 *  用于当前控制器有`多个`自定义转场代理对象,可以区分不同的转场代理。
 *  需要初始化一个`HGTransitionAnimator`实例化对象,并且`animator`需要被当前控制器强引用。
 *
 *  @param viewControllerToPresent  需要转场出来的控制器
 *  @param animator                 转场代理对象
 */
- (void)hg_presentViewController:(nonnull UIViewController *)viewControllerToPresent
                        animator:(nonnull HGTransitionAnimator *)animator;

/**
 *  dismiss控制器,并销毁控制器,一定会在主线程里面执行
 *
 *  @param flag       是否需要动画
 *  @param completion 完成之后的操作block
 */
- (void)hg_dismissViewControllerAnimated:(BOOL)flag
                              completion:(void (^ __nullable)(void))completion;

/**
 *  获取负责转场的对象,在被转场对象中需要时可以获取
 */
@property (nonatomic, strong, readonly, nullable) HGPresentationController *hg_presentationController;

@end

NS_ASSUME_NONNULL_END

