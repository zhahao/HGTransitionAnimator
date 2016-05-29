//
//  UIViewController+HGTransition.m
//  HGTransitionAnimator
//
//  Created by 查昊 on 16/5/25.
//  Copyright © 2016年 haocha. All rights reserved.
//

#import "UIViewController+HGAnimator.h"
#import "HGTransitionAnimator.h"
#import <objc/runtime.h>

static NSString *const HGTransitionAnimatorKey=@"HGTransitionAnimatorKey";
@implementation UIViewController (HGAnimator)
-(HGTransitionAnimator *)hg_presentViewController:(UIViewController *)viewControllerToPresent animateStyle:(HGTransitionAnimatorStyle)style delegate:(id<HGTransitionAnimatorDelegate>)delegate presentFrame:(CGRect)presentFrame backgroundColor:(UIColor *)backgroundColor animated:(BOOL)flag
{
    UIView* relateView=self.view;
    HGTransitionAnimator *animator=[[HGTransitionAnimator alloc]initWithAnimateStyle:style relateView:relateView  presentFrame:presentFrame backgroundColor:backgroundColor delegate:delegate animated:flag];
    objc_setAssociatedObject(self, &HGTransitionAnimatorKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &HGTransitionAnimatorKey, animator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    viewControllerToPresent.modalPresentationStyle=UIModalPresentationCustom;
    viewControllerToPresent.transitioningDelegate=animator;
    [self presentViewController:viewControllerToPresent animated:flag completion:nil];
    return  animator;
}

- (HGTransitionAnimator *)hg_dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    HGTransitionAnimator *animator=(HGTransitionAnimator *)self.transitioningDelegate;
    if (!flag) [animator transitionDuration:0];
    [self dismissViewControllerAnimated:flag completion:completion];
    return animator;
}
@end
