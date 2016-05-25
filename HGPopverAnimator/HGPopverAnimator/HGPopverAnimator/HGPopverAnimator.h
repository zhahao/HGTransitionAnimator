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

@property (nonatomic, assign) CGRect presentFrame;//<- 弹出视图的的frame
@property (nonatomic, assign,nullable) id<HGPopverAnimatorDelegate> delegate;
@property (nonatomic, assign) HGPopverAnimatorStyle animateStyle;//<- push样式
@property (nonatomic, weak) UIView *relateView;//<-参照的View
@property (nonatomic, assign) BOOL animated;//<- 是否动画

@property (nonatomic, assign) NSTimeInterval duration;//<- 动画时间 deflaut=0.25s
@property (nonatomic, assign) NSTimeInterval pushDuration;//<- push动画时间 deflaut=0.25s
@property (nonatomic, assign) NSTimeInterval popDuration;//<- pop动画时间 deflaut=0.25s
@property (nonatomic, strong) UIColor *backgroundColor;//<- 蒙版背景色
@property (nonatomic, assign) BOOL fullScreen;// <-全屏
NS_ASSUME_NONNULL_END
@end
