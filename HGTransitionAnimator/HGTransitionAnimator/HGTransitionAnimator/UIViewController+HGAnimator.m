//
//  UIViewController+HGTransition.m
//  HGTransitionAnimator
//
//  Created by 查昊 on 16/5/25.
//  Copyright © 2016年 haocha. All rights reserved.
//

#import "UIViewController+HGAnimator.h"
#import <objc/runtime.h>

static char kTransitionAnimatorKey;

@implementation UIViewController (HGAnimator)

- (void)hg_presentViewController:(UIViewController *)viewControllerToPresent
                    animateStyle:(HGTransitionAnimatorStyle)style
                        delegate:(id<HGTransitionAnimatorDelegate>)delegate
                    presentFrame:(CGRect)presentFrame
                 backgroundColor:(UIColor *)backgroundColor
                        animated:(BOOL)flag
  invokeSourceVCLifeCycleMethods:(BOOL)invokeSourceVCLifeCycleMethods
{
    HGTransitionAnimator *animator = [[HGTransitionAnimator alloc]initWithAnimateStyle:style
                                                                            relateView:self.view
                                                                          presentFrame:presentFrame
                                                                       backgroundColor:backgroundColor
                                                                              delegate:delegate
                                                                              animated:flag];
    animator.invokeSourceVCLifeCycleMethods = invokeSourceVCLifeCycleMethods;
    
    objc_setAssociatedObject(self, &kTransitionAnimatorKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &kTransitionAnimatorKey, animator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self hg_presentViewController:viewControllerToPresent animator:animator];
    
}

- (void)hg_presentViewController:(UIViewController *)viewControllerToPresent
                    animateStyle:(HGTransitionAnimatorStyle)style
                        delegate:(id<HGTransitionAnimatorDelegate>)delegate
                    presentFrame:(CGRect)presentFrame
                 backgroundColor:(UIColor *)backgroundColor
                        animated:(BOOL)flag {
    [self hg_presentViewController:viewControllerToPresent animateStyle:style delegate:delegate presentFrame:presentFrame backgroundColor:backgroundColor animated:flag invokeSourceVCLifeCycleMethods:NO];
}

- (void)hg_presentViewController:(UIViewController *)viewControllerToPresent animator:(HGTransitionAnimator *)animator
{
    viewControllerToPresent.modalPresentationStyle = UIModalPresentationCustom;
    viewControllerToPresent.transitioningDelegate = animator;
    [self presentViewController:viewControllerToPresent animated:YES completion:nil];
}

- (void)hg_dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    HGTransitionAnimator *animator = (HGTransitionAnimator *)self.presentedViewController.transitioningDelegate;
    
    if ([animator isKindOfClass:[HGTransitionAnimator class]] && !flag) {
        [animator transitionDuration:0];
    }
    
    [self dismissViewControllerAnimated:flag completion:^{
        if (completion) {
            completion();
        }
        
        if ([animator isKindOfClass:[HGTransitionAnimator class]]) {
            objc_setAssociatedObject(animator.sourceViewController, &kTransitionAnimatorKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }];
}

- (HGPresentationController *)hg_presentationController
{
    HGTransitionAnimator *animator = (HGTransitionAnimator *)self.transitioningDelegate;
    if (animator == nil) return nil;
    return animator.presentationController;
}

@end



