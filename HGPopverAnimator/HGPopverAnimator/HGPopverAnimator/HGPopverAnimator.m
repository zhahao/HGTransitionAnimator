//
//  HGTransitioningDelegate.m
//  自定义转场动画_OC
//
//  Created by 查昊 on 16/5/23.
//  Copyright © 2016年 haocha. All rights reserved.
//

#import "HGPopverAnimator.h"
#import "HGPresentationController.h"
#import "UIView+Extension.h"
#import <objc/runtime.h>


@interface  HGPopverAnimator()
@property (nonatomic, assign) BOOL  willPresent;
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
@end


static const char *HGPresentationControllerKey="HGPresentationControllerKey";
@implementation HGPopverAnimator
-(instancetype)initWithAnimateStyle:(HGPopverAnimatorStyle)animateStyle relateView:(UIView *)relateView presentFrame:(CGRect)presentFrame delegate:(id<HGPopverAnimatorDelegate>)delegate fullScreen:(BOOL)fullScreen animated:(BOOL)animated
{
    if (self=[super init]) {
        #define SETTER(hg_property) _##hg_property=(hg_property)
        SETTER(animateStyle);
        SETTER(relateView);
        SETTER(presentFrame);
        SETTER(delegate);
        SETTER(fullScreen);
        SETTER(animated);
        
        _duration=_animated? 0.5:0;
        _backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    }
    return self;
}

-(UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    HGPresentationController*pc=nil;
    if ([self getPresentationController]) {
        pc=[self getPresentationController];
    }else{
        pc=[[HGPresentationController alloc]initWithPresentedViewController:presented presentingViewController:presenting];
        pc.presentFrame=self.presentFrame;
//        if ([presented.presentedViewController.transitioningDelegate isKindOfClass:[self class]]){
//            pc.firstPresent=NO;
//        }
        objc_setAssociatedObject(self, &HGPresentationControllerKey, pc, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
    }
    return pc;

}
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.willPresent=YES;
    if (_delegate&&[_delegate respondsToSelector:@selector(popverAnimationControllerForPresentedController:)]) {
        [self.delegate popverAnimationControllerForPresentedController:source];
    }
    return self;
}
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.willPresent=NO;
    if (_delegate&&[_delegate respondsToSelector:@selector(popverAnimationControllerForDismissedController:)]) {
        [self.delegate popverAnimationControllerForDismissedController:dismissed];
    }
    return self;
}
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(popverTransitionDuration)]){
        return [self.delegate popverTransitionDuration];
       };
    return _duration;
}
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *coverView=[self getPresentationControllerCoverView];
    if (_willPresent) {
         UIView *toView=[transitionContext viewForKey:UITransitionContextToViewKey];
        [[transitionContext containerView] addSubview:toView];
        if (_animateStyle==HGPopverAnimatorCustomStyle) { // 自定义
            NSAssert(self.delegate&&[self.delegate respondsToSelector:@selector(popverAnimateTransitionToView:duration:)], @"必须实现animateTransitionToView:duration:代理方法!");
                [self.delegate popverAnimateTransitionToView:toView duration:_duration];
            [UIView animateWithDuration:_duration animations:^{
                coverView.backgroundColor=_backgroundColor;
            } completion:^(BOOL finished) {
                [transitionContext completeTransition:YES];
            }];

        }else{
            [self setupPushAnimator:toView context:transitionContext coverView:coverView];
        }
    }else{
        UIView *fromView=[transitionContext viewForKey:UITransitionContextFromViewKey];
        if (_animateStyle==HGPopverAnimatorCustomStyle) { // 自定义
            NSAssert(self.delegate&&[self.delegate respondsToSelector:@selector(popverAnimateTransitionFromView:duration:)], @"必须实现animateTransitionFromView:duration:代理方法!");
                [_delegate popverAnimateTransitionFromView:fromView duration:_duration];
                [UIView animateWithDuration:_duration animations:^{
                    coverView.backgroundColor=[UIColor clearColor];
                } completion:^(BOOL finished) {
                    [transitionContext completeTransition:YES];
                }];
        }else{
            [self setupPopAnimator:fromView context:transitionContext coverView:coverView];
        }
    }
    
}

//static inline CGRect VerticalMoveToTop (CGRect rect){
//    return CGRectMake(0, 0, 0, 0);
//}
//static inline CGRect VerticalMoveToBottom (CGRect rect){
//    return CGRectMake(0, 0, 0, 0);
//}
//static inline CGRect HorizontalMoveToTop (CGRect rect){
//    return CGRectMake(0, 0, 0, 0);
//}
//static inline CGRect HorizontalMoveToBottom (CGRect rect){
//    return CGRectMake(0, 0, 0, 0);
//}
- (CGRect)relateViewToWindow
{
    return  [self.relateView convertRect:self.relateView.bounds toView:[[UIApplication sharedApplication] keyWindow]];
}
- (CGFloat)relateViewXToWindow
{
    return [self relateViewToWindow].origin.x;
}
- (CGFloat)relateViewYToWindow
{
    return [self relateViewToWindow].origin.y;
}

// pop
- (void)setupPopAnimator:(UIView *)toView context:(id<UIViewControllerContextTransitioning>)transitionContext coverView:(UIView *)coverView
{
    if (_animateStyle==HGPopverAnimatorFromLeftStyle) {
        toView.hidden=YES;
        toView.x=[self relateViewXToWindow]-toView.width;
        toView.hidden=NO;
        [UIView animateWithDuration:_duration animations:^{
            toView.x=[self relateViewXToWindow];
            coverView.backgroundColor=_backgroundColor;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }else if (_animateStyle==HGPopverAnimatorFromRightStyle){
        toView.hidden=YES;
        toView.x=[self relateViewXToWindow]+toView.width;
        toView.hidden=NO;
        [UIView animateWithDuration:_duration animations:^{
            toView.x=[self relateViewXToWindow]+self.relateView.width-toView.width;
            coverView.backgroundColor=_backgroundColor;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }else if (_animateStyle==HGPopverAnimatorFromTopStyle){
        toView.hidden=YES;
        toView.y=[self relateViewYToWindow]-toView.height;
        toView.hidden=NO;
        [UIView animateWithDuration:_duration animations:^{
            toView.y=self.relateView.y+self.relateView.height;
            coverView.backgroundColor=_backgroundColor;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }else if (_animateStyle==HGPopverAnimatorFromBottomStyle){
        toView.hidden=YES;
        toView.y=CGRectGetMaxY(toView.frame);
        toView.hidden=NO;
        [UIView animateWithDuration:_duration animations:^{
            toView.y=[self relateViewYToWindow]+self.relateView.height-toView.height;
            coverView.backgroundColor=_backgroundColor;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }else if (_animateStyle==HGPopverAnimatorVerticalScaleStyle){
        [UIView animateWithDuration:_duration animations:^{
            toView.transform=CGAffineTransformMakeScale(1.0, 0.0000001);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }else if (_animateStyle==HGPopverAnimatorHorizontalScaleStyle){
        [UIView animateWithDuration:_duration animations:^{
            toView.transform=CGAffineTransformMakeScale(0.0000001, 1.0);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }

}
/*
     HGPopverAnimatorFromLeftStyle,          //从左边弹出样式
     HGPopverAnimatorFromRightStyle,         //从右边弹出样式
     HGPopverAnimatorFromTopStyle,           //从顶部弹出样式
     HGPopverAnimatorFromBottomStyle,        //从底部弹出样式
     HGPopverAnimatorVerticalScaleStyle,     //垂直压缩样式
     HGPopverAnimatorHorizontalScaleStyle,   //水平压缩样式
 */
// push
- (void)setupPushAnimator:(UIView *)fromView context:(id<UIViewControllerContextTransitioning>)transitionContext coverView:(UIView *)coverView

{
    if (_animateStyle==HGPopverAnimatorFromLeftStyle) {
        fromView.hidden=YES;
        fromView.x=[self relateViewXToWindow]-fromView.width;
        fromView.hidden=NO;
        [UIView animateWithDuration:_duration animations:^{
            fromView.x=[self relateViewXToWindow];
            coverView.backgroundColor=_backgroundColor;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }else if (_animateStyle==HGPopverAnimatorFromRightStyle){
        fromView.hidden=YES;
        fromView.x=[self relateViewXToWindow]+fromView.width;
        fromView.hidden=NO;
        [UIView animateWithDuration:_duration animations:^{
            fromView.x=[self relateViewXToWindow]+self.relateView.width-fromView.width;
            coverView.backgroundColor=_backgroundColor;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }else if (_animateStyle==HGPopverAnimatorFromTopStyle){
        fromView.hidden=YES;
        fromView.y=[self relateViewYToWindow]-fromView.height;
        fromView.hidden=NO;
        [UIView animateWithDuration:_duration animations:^{
            fromView.y=[self relateViewYToWindow];
            coverView.backgroundColor=_backgroundColor;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }else if (_animateStyle==HGPopverAnimatorFromBottomStyle){
        fromView.hidden=YES;
        fromView.y=CGRectGetMaxY(fromView.frame);
        fromView.hidden=NO;
        [UIView animateWithDuration:_duration animations:^{
            fromView.y=[self relateViewYToWindow]+self.relateView.height-fromView.height;
            coverView.backgroundColor=_backgroundColor;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }else if (_animateStyle==HGPopverAnimatorVerticalScaleStyle){
        [UIView animateWithDuration:_duration animations:^{
            fromView.transform=CGAffineTransformMakeScale(1.0, 0.0000001);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }else if (_animateStyle==HGPopverAnimatorHorizontalScaleStyle){
        [UIView animateWithDuration:_duration animations:^{
            fromView.transform=CGAffineTransformMakeScale(0.0000001, 1.0);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}
- (UIView *)getPresentationControllerCoverView
{
    return [self getPresentationController].coverView;
}
- (HGPresentationController *)getPresentationController
{
    return  objc_getAssociatedObject(self, &HGPresentationControllerKey);
}

@end
