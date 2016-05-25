//
//  UIViewController+HGPopver.m
//  HGPopverAnimator
//
//  Created by 查昊 on 16/5/25.
//  Copyright © 2016年 haocha. All rights reserved.
//

#import "UIViewController+HGPopver.h"
#import "HGPopverAnimator.h"
#import <objc/runtime.h>

static NSString *const HGPopverAnimatorKey=@"HGPopverAnimatorKey";

@implementation UIViewController (HGPopver)
-(void)presentViewController:(UIViewController *)viewControllerToPresent animateStyle:(HGPopverAnimatorStyle)style delegate:(id<HGPopverAnimatorDelegate>)delegate presentFrame:(CGRect)presentFrame relateView:(UIView *)relateView animated:(BOOL)flag
{
    if (relateView==nil) relateView=self.view;
    objc_setAssociatedObject(self, &HGPopverAnimatorKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    HGPopverAnimator *pa=[[HGPopverAnimator alloc]init];
    pa.delegate=delegate;
    pa.animateStyle=style;
    pa.relateView=relateView;
    pa.animated=flag;
    pa.presentFrame=presentFrame;
    pa.fullScreen=CGRectEqualToRect(self.view.frame, relateView.frame);
    objc_setAssociatedObject(self, &HGPopverAnimatorKey, pa, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    viewControllerToPresent.modalPresentationStyle=UIModalPresentationCustom;
    viewControllerToPresent.transitioningDelegate=pa;

    [self presentViewController:viewControllerToPresent animated:flag completion:nil];
}
@end
