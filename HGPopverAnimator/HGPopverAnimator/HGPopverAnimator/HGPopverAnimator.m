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
-(void)animatorWithShowComplated:(complatedBlcok)showComplated dismissComplated:(complatedBlcok)dismissComplated
{
    if (showComplated!=NULL)              _showComplatedBlcok=[showComplated copy];
    if (dismissComplated!=NULL)           _dismissComplatedBlcok=[dismissComplated copy];
}
-(void)setToViewAnimateTransition:(toViewAnimateBlcok)toViewAnimateBlcok showComplated:(complatedBlcok)complated
{
    NSAssert(toViewAnimateBlcok!=NULL,@"必须要实现转场动画");
    if (toViewAnimateBlcok!=NULL)          _toViewAnimateBlcok=[toViewAnimateBlcok copy];
    if (complated!=NULL)                   _showComplatedBlcok=[complated copy];
}
-(void)setFromViewAnimateTransition:(fromViewAnimateBlcok)fromViewAnimateBlcok dismissComplated:(complatedBlcok)complated
{
    NSAssert(fromViewAnimateBlcok!=NULL,@"必须要实现转场动画");
    if (fromViewAnimateBlcok!=NULL)        _fromViewAnimateBlcok=[fromViewAnimateBlcok copy];
    if (complated!=NULL)                   _dismissComplatedBlcok=[complated copy];
}
-(instancetype)init
{
    if (self=[super init]) {
        _duration=0.25;
        _popDuration=_duration;
        _pushDuration=_duration;
    }
    return self;
}
-(UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    HGPresentationController *pc=[[HGPresentationController alloc]initWithPresentedViewController:presented presentingViewController:presenting];
    pc.presentFrame=self.presentFrame;
    if ([presented.presentedViewController.transitioningDelegate isKindOfClass:[self class]]){
        pc.firstPresent=NO;
    }
    objc_setAssociatedObject(self, &HGPresentationControllerKey, pc, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return pc;

}
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.willPresent=YES;
    if (_showComplatedBlcok!=NULL) _showComplatedBlcok();
    return self;
}
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.willPresent=NO;
    if (_dismissComplatedBlcok!=NULL) _dismissComplatedBlcok();
    return self;
}
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return _duration;
}
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    __weak typeof(self) weakSelf=self;
    if (_willPresent) {
        __weak UIView *toView=[transitionContext viewForKey:UITransitionContextToViewKey];
        [[transitionContext containerView] addSubview:toView];
        if (_animateStyle==HGPopverAnimatorCustomStyle) { // 自定义
            if (_toViewAnimateBlcok){
                _toViewAnimateBlcok(toView,weakSelf.duration);
                [transitionContext completeTransition:YES];
            }
        }else{
            [self setupPushAnimator:toView context:transitionContext];
        }
    }else{
        __weak UIView *fromView=[transitionContext viewForKey:UITransitionContextFromViewKey];
        if (_animateStyle==HGPopverAnimatorCustomStyle) { // 自定义
            if (_fromViewAnimateBlcok){
                UIView *coverView=[self getPresentationControllerCoverView];
                [UIView animateWithDuration:weakSelf.duration animations:^{
                    _fromViewAnimateBlcok(fromView,weakSelf.duration +0.00001);
                    coverView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
                } completion:^(BOOL finished) {
                    [transitionContext completeTransition:YES];
                }];
            }
        }else{
            UIView *coverView=[fromView.superview viewWithTag:1000];
            [UIView animateWithDuration:weakSelf.duration animations:^{
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
@end

