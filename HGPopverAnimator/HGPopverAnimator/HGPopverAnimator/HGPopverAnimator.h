//
//  HGTransitioningDelegate.h
//  自定义转场动画_OC
//
//  Created by 查昊 on 16/5/23.
//  Copyright © 2016年 haocha. All rights reserved.
//

#import "HGPopverAnimatorDelegate.h"
typedef NS_ENUM(NSInteger,HGPopverAnimatorStyle)
{
    HGPopverAnimatorCustomStyle=0,          //自定义样式
    HGPopverAnimatorFromLeftStyle,          //从左边弹出样式
    HGPopverAnimatorFromRightStyle,         //从右边弹出样式
    HGPopverAnimatorFromTopStyle,           //从顶部弹出样式
    HGPopverAnimatorFromBottomStyle,        //从底部弹出样式
    HGPopverAnimatorVerticalScaleStyle,     //垂直压缩样式
    HGPopverAnimatorHorizontalScaleStyle,   //水平压缩样式

};
NS_ASSUME_NONNULL_BEGIN
@interface HGPopverAnimator : NSObject<UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning>

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new  NS_UNAVAILABLE;

- (instancetype)initWithAnimateStyle:(HGPopverAnimatorStyle)animateStyle relateView:(nullable UIView *)relateView presentFrame:(CGRect)presentFrame delegate:(nullable id <HGPopverAnimatorDelegate>)delegate fullScreen:(BOOL)fullScreen animated:(BOOL)animated;

NS_ASSUME_NONNULL_END
@end
