//
//  UIViewController+HGTransition.h
//  HGTransitionAnimator
//
//  Created by 查昊 on 16/5/25.
//  Copyright © 2016年 haocha. All rights reserved.
//

#import "HGTransitionAnimator.h"

NS_ASSUME_NONNULL_BEGIN
@interface UIViewController (HGAnimator)
/**
 *  自定义弹出控制器,一定会在主线程里面执行
 *
 *  @param viewControllerToPresent 需要转场出来的控制器
 *  @param style                   转场样式
 *  @param delegate                代理,如果不自定义转场动画,设置为空即可
 *  @param presentFrame            转场控制器的视图frame,相对于window的frame
 *  @param flag                    是否需要动画效果
 *  @return                        转场动画代理对象
 */
- (HGTransitionAnimator *_Nonnull)hg_presentViewController:(nonnull UIViewController *)viewControllerToPresent
                                      animateStyle:(HGTransitionAnimatorStyle )style
                                          delegate:(nullable id <HGTransitionAnimatorDelegate>)delegate
                                      presentFrame:(CGRect)presentFrame
                                   backgroundColor:(nonnull UIColor *)backgroundColor
                                          animated:(BOOL)flag;
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
- (HGPresentationController * _Nonnull)hg_getPresentationController;
@end
NS_ASSUME_NONNULL_END

