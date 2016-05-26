//
//  UIViewController+HGPopver.h
//  HGPopverAnimator
//
//  Created by 查昊 on 16/5/25.
//  Copyright © 2016年 haocha. All rights reserved.
//

#import "HGPopverAnimator.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (HGPopver)

- (void)presentViewController:(nonnull UIViewController *)viewControllerToPresent animateStyle:(HGPopverAnimatorStyle )style delegate:(nullable id <HGPopverAnimatorDelegate>)delegate presentFrame:(CGRect)presentFrame relateView:(nullable UIView *)relateView animated:(BOOL)flag;

- (void)dismissViewControllerPopver;
@end

NS_ASSUME_NONNULL_END