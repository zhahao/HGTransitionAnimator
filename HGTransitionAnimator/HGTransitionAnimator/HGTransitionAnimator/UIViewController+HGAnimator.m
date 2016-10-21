//
//  UIViewController+HGTransition.m
//  HGTransitionAnimator
//
//  Created by 查昊 on 16/5/25.
//  Copyright © 2016年 haocha. All rights reserved.
//

#import "UIViewController+HGAnimator.h"
#import <objc/runtime.h>

static NSString * const HGTransitionAnimatorKey = @"HGTransitionAnimatorKey";

@implementation UIViewController (HGAnimator)

- (void)hg_presentViewController:(UIViewController *)viewControllerToPresent
                    animateStyle:(HGTransitionAnimatorStyle)style
                        delegate:(id<HGTransitionAnimatorDelegate>)delegate
                    presentFrame:(CGRect)presentFrame
                 backgroundColor:(UIColor *)backgroundColor
                        animated:(BOOL)flag
{
    HGTransitionAnimator *animator = [[HGTransitionAnimator alloc]initWithAnimateStyle:style
                                                                            relateView:self.view
                                                                          presentFrame:presentFrame
                                                                       backgroundColor:backgroundColor
                                                                              delegate:delegate
                                                                              animated:flag];
    
    objc_setAssociatedObject(self, &HGTransitionAnimatorKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &HGTransitionAnimatorKey, animator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self hg_presentViewController:viewControllerToPresent animator:animator];
    
}

- (void)hg_presentViewController:(UIViewController *)viewControllerToPresent animator:(HGTransitionAnimator *)animator
{
    viewControllerToPresent.modalPresentationStyle = UIModalPresentationCustom;
    viewControllerToPresent.transitioningDelegate = animator;
    dispatch_main_async_safe(^{
        [self presentViewController:viewControllerToPresent animated:YES completion:nil];
    });
}
- (void)hg_dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    HGTransitionAnimator *animator = (HGTransitionAnimator *)self.transitioningDelegate;
    if (!flag) [animator transitionDuration:0];
    dispatch_main_async_safe(^{
        [self dismissViewControllerAnimated:flag completion:completion];
    });
    objc_setAssociatedObject([self currentPresentingViewController], &HGTransitionAnimatorKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HGPresentationController *)hg_presentationController
{
    HGTransitionAnimator *animator = (HGTransitionAnimator *)self.transitioningDelegate;
    if (animator == nil) return nil;
    return animator.presentationController;
}

- (UIViewController *)currentPresentingViewController
{
    if ([self.presentingViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)self.presentingViewController;
        return  [nav.viewControllers lastObject];;
    }
    return  self.presentingViewController;
}
@end



