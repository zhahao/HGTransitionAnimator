//
//  HGTransitioningDelegate.m
//  自定义转场动画_OC
//
//  Created by 查昊 on 16/5/23.
//  Copyright © 2016年 haocha. All rights reserved.
//

#import "HGPopverAnimator.h"
#import "HGPresentationController.h"
#import <objc/runtime.h>


@interface  HGPopverAnimator()
@property (nonatomic, assign) BOOL  willPresent;
@property (nonatomic, copy) toViewAnimateBlcok toViewAnimateBlcok;
@property (nonatomic, copy) fromViewAnimateBlcok fromViewAnimateBlcok;
@property (nonatomic, copy) complatedBlcok   showComplatedBlcok;
@property (nonatomic, copy) complatedBlcok   dismissComplatedBlcok;
@end
static const char   *HGPresentationControllerKey="HGPresentationController";
@implementation HGPopverAnimator
-(instancetype)init
{
    if (self=[super init]) {
        _duration=_animated? 0.25:0;
        _popDuration=_duration;
        _pushDuration=_duration;
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
        if ([presented.presentedViewController.transitioningDelegate isKindOfClass:[self class]]){
            pc.firstPresent=NO;
        }
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
    return _duration;
}
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if (_willPresent) {
         UIView *toView=[transitionContext viewForKey:UITransitionContextToViewKey];
        [[transitionContext containerView] addSubview:toView];
        if (_animateStyle==HGPopverAnimatorCustomStyle) { // 自定义
            NSAssert(self.delegate&&[self.delegate respondsToSelector:@selector(popverAnimateTransitionToView:duration:)], @"请实现animateTransitionToView:duration:代理方法");
                [self.delegate popverAnimateTransitionToView:toView duration:_pushDuration];
                [transitionContext completeTransition:YES];
        }else{
            [self setupPushAnimator:toView context:transitionContext];
        }
    }else{
        __weak UIView *fromView=[transitionContext viewForKey:UITransitionContextFromViewKey];
        if (_animateStyle==HGPopverAnimatorCustomStyle) { // 自定义
            NSAssert(self.delegate&&[self.delegate respondsToSelector:@selector(popverAnimateTransitionFromView:duration:)], @"animateTransitionFromView:duration:代理方法");
                [_delegate popverAnimateTransitionFromView:fromView duration:_popDuration];
                UIView *coverView=[fromView.superview viewWithTag:1000];
                objc_getAssociatedObject(self, &HGPresentationControllerKey);
                [UIView animateWithDuration:_popDuration animations:^{
                    _fromViewAnimateBlcok(fromView,self.duration +0.00001);
                    coverView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
                } completion:^(BOOL finished) {
                    [transitionContext completeTransition:YES];
                }];
        }else{
            UIView *coverView=[fromView.superview viewWithTag:1000];
            [UIView animateWithDuration:self.duration animations:^{
                coverView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
            } completion:^(BOOL finished) {
                [transitionContext completeTransition:YES];
            }];
            [self setupPushAnimator:fromView context:transitionContext];
        }
    }
    
}
- (void)setupPopAnimator:(UIView *)toView context:(id<UIViewControllerContextTransitioning>)transitionContext
{
    __weak typeof(self) weakSelf=self;
    CGRect tmpRect=toView.frame;
    if (_animateStyle==HGPopverAnimatorFromBottomStyle) {
        toView.hidden=YES;
        tmpRect.origin.y=CGRectGetMaxY(toView.frame);
        toView.hidden=NO;
        [UIView animateWithDuration:weakSelf.duration animations:^{
            toView.frame=tmpRect;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }else if (_animateStyle==HGPopverAnimatorFromRightStyle){
        tmpRect.origin.x=CGRectGetMaxX(toView.frame);
        [UIView animateWithDuration:weakSelf.duration animations:^{
            toView.frame=tmpRect;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }else if (_animateStyle==HGPopverAnimatorVerticalScaleStyle){
        [UIView animateWithDuration:weakSelf.duration animations:^{
            toView.transform=CGAffineTransformMakeScale(1.0, 0.0000001);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}

- (void)setupPushAnimator:(UIView *)fromView context:(id<UIViewControllerContextTransitioning>)transitionContext

{
    __weak typeof(self) weakSelf=self;
    CGRect tmpRect=fromView.frame;
    CGFloat W=fromView.frame.size.width;
    CGFloat H=fromView.frame.size.height;
    if (_animateStyle==HGPopverAnimatorFromBottomStyle) {
        tmpRect.origin.y=H+CGRectGetMaxY(fromView.frame);
        fromView.frame=tmpRect;
        CGRect tmp1=fromView.frame;
        tmp1.origin.y=0;
        [UIView animateWithDuration:weakSelf.duration animations:^{
            fromView.frame=tmp1;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }else if (_animateStyle==HGPopverAnimatorFromRightStyle){
        tmpRect.origin.x=W+CGRectGetMaxX(fromView.frame);
        fromView.frame=tmpRect;
        CGRect tmp1=fromView.frame;
        tmp1.origin.x=0;
        [UIView animateWithDuration:weakSelf.duration animations:^{
            fromView.frame=tmp1;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }else if (_animateStyle==HGPopverAnimatorVerticalScaleStyle){
        fromView.layer.anchorPoint=CGPointMake(0.5, 0);
        fromView.transform=CGAffineTransformMakeScale(1.0, 0.0);
        [UIView animateWithDuration:weakSelf.duration animations:^{
            fromView.transform=CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}
- (UIView *)getPresentationControllerCoverView
{
    HGPresentationController *pc=objc_getAssociatedObject(self, &HGPresentationControllerKey);
    return pc.coverView;
}
- (HGPresentationController *)getPresentationController
{
    return  objc_getAssociatedObject(self, &HGPresentationControllerKey);
}

@end

