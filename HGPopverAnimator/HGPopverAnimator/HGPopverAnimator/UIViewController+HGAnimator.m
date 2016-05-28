//
//  UIViewController+HGPopver.m
//  HGPopverAnimator
//
//  Created by 查昊 on 16/5/25.
//  Copyright © 2016年 haocha. All rights reserved.
//

#import "UIViewController+HGAnimator.h"
#import "HGPopverAnimator.h"
#import <objc/runtime.h>

static NSString *const HGPopverAnimatorKey=@"HGPopverAnimatorKey";
@implementation UIViewController (HGAnimator)
-(HGPopverAnimator *)hg_presentViewController:(UIViewController *)viewControllerToPresent animateStyle:(HGPopverAnimatorStyle)style delegate:(id<HGPopverAnimatorDelegate>)delegate presentFrame:(CGRect)presentFrame backgroundColor:(UIColor *)backgroundColor animated:(BOOL)flag
{
    UIView* relateView=self.view;
    objc_setAssociatedObject(self, &HGPopverAnimatorKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    HGPopverAnimator *popver=[[HGPopverAnimator alloc]initWithAnimateStyle:style relateView:relateView  presentFrame:presentFrame backgroundColor:backgroundColor delegate:delegate animated:flag];
    objc_setAssociatedObject(self, &HGPopverAnimatorKey, popver, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    viewControllerToPresent.modalPresentationStyle=UIModalPresentationCustom;
    viewControllerToPresent.transitioningDelegate=popver;
    [self presentViewController:viewControllerToPresent animated:flag completion:nil];
    return  popver;
}

- (HGPopverAnimator *)hg_dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    HGPopverAnimator *popver=(HGPopverAnimator *)self.transitioningDelegate;
    if (!flag) [popver transitionDuration:0];
    [self dismissViewControllerAnimated:flag completion:completion];
    return popver;
}
@end
