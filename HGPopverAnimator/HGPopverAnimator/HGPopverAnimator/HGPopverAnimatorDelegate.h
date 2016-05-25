//
//  HGPopverAnimatorDelegate.h
//  HGPopverAnimator
//
//  Created by 查昊 on 16/5/25.
//  Copyright © 2016年 haocha. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HGPopverAnimatorDelegate <NSObject>
@optional
- (void)popverAnimationControllerForPresentedController:(UIViewController *)presented;
- (void)popverAnimationControllerForDismissedController:(UIViewController *)dismissed;

- (void)popverAnimateTransitionToView:(UIView *)toView duration:(NSTimeInterval)duration;
- (void)popverAnimateTransitionFromView:(UIView *)fromView duration:(NSTimeInterval)duration;
@end
