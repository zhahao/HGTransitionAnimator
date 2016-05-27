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

#define SETTER(hg_property) _##hg_property=(hg_property)
#define kWeakSelf __weak __typeof(self)weakSelf = self;
static const CGFloat defaultDuratin=0.524;
@interface  HGPopverAnimator()
@property (nonatomic, assign) BOOL  willPresent;
@property (nonatomic, assign) CGRect presentFrame;//<- 弹出视图的的frame
@property (nonatomic, assign,nullable) id<HGPopverAnimatorDelegate> delegate;//<- 代理
@property (nonatomic, assign) HGPopverAnimatorStyle animateStyle;//<- push样式
@property (nonatomic, weak) UIView *relateView;//<-参照的View
@property (nonatomic, assign) BOOL animated;//<- 是否动画
@property (nonatomic, assign) NSTimeInterval duration;//<- 动画时间 deflaut=0.25s
@property (nonatomic, strong) UIColor *backgroundColor;//<- 蒙版背景色
@property (nonatomic, assign) BOOL fullScreen;// <-全屏
@end


static const char *HGPresentationControllerKey="HGPresentationControllerKey";
@implementation HGPopverAnimator
-(instancetype)initWithAnimateStyle:(HGPopverAnimatorStyle)animateStyle relateView:(UIView *)relateView presentFrame:(CGRect)presentFrame delegate:(id<HGPopverAnimatorDelegate>)delegate fullScreen:(BOOL)fullScreen animated:(BOOL)animated
{
    if (self=[super init]) {
        SETTER(animateStyle);
        SETTER(relateView);
        SETTER(presentFrame);
        SETTER(delegate);
        SETTER(fullScreen);
        SETTER(animated);
        _duration=_animated? defaultDuratin:0;
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
        objc_setAssociatedObject(self, &HGPresentationControllerKey, pc, OBJC_ASSOCIATION_ASSIGN);
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
        _duration=[self.delegate popverTransitionDuration];
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
            NSAssert(self.delegate&&[self.delegate respondsToSelector:@selector(popverAnimateTransitionToView:duration:)], @"自定义样式必须实现animateTransitionToView:duration:代理方法!");
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
            NSAssert(self.delegate&&[self.delegate respondsToSelector:@selector(popverAnimateTransitionFromView:duration:)], @"自定义样式必须实现animateTransitionFromView:duration:代理方法!");
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

// pop
- (void)setupPopAnimator:(UIView *)fromView context:(id<UIViewControllerContextTransitioning>)transitionContext coverView:(UIView *)coverView
{
    kWeakSelf;
    if (_animateStyle==HGPopverAnimatorFromLeftStyle) {
        [self toView:fromView context:transitionContext animations:^{
            fromView.x=[self relateViewXToWindow]-fromView.width; }];
    }else if (_animateStyle==HGPopverAnimatorFromRightStyle){
        [self toView:fromView context:transitionContext animations:^{
            fromView.x=[self relateViewXToWindow]+weakSelf.relateView.width; }];
    }else if (_animateStyle==HGPopverAnimatorFromTopStyle){
        [self toView:fromView context:transitionContext animations:^{
            fromView.y=[self relateViewXToWindow]-fromView.height; }];
    }else if (_animateStyle==HGPopverAnimatorFromBottomStyle){
        [self toView:fromView context:transitionContext animations:^{
            fromView.y=[self relateViewYToWindow]+weakSelf.relateView.height+fromView.height; }];
    }else if (_animateStyle==HGPopverAnimatorVerticalScaleStyle){
        [self toView:fromView context:transitionContext animations:^{
            fromView.transform=CGAffineTransformMakeScale(1.0, 0.000001); }];
    }else if (_animateStyle==HGPopverAnimatorHorizontalScaleStyle){
        [self toView:fromView context:transitionContext animations:^{
            fromView.transform=CGAffineTransformMakeScale(0.000001, 1.0); }];
    }
}
// push
- (void)setupPushAnimator:(UIView *)toView context:(id<UIViewControllerContextTransitioning>)transitionContext coverView:(UIView *)coverView
{
    kWeakSelf
    if (_animateStyle==HGPopverAnimatorFromLeftStyle) {
        [self fromView:toView context:transitionContext actions:^{
            toView.x=[weakSelf relateViewXToWindow]-toView.width;
        } animations:^{ toView.x=[weakSelf relateViewXToWindow]; }];
    }else if (_animateStyle==HGPopverAnimatorFromRightStyle){
        [self fromView:toView context:transitionContext actions:^{
            toView.x=[self relateViewXToWindow]+toView.width;
        } animations:^{ toView.x=[self relateViewXToWindow]+self.relateView.width-toView.width; }];
    }else if (_animateStyle==HGPopverAnimatorFromTopStyle){
        [self fromView:toView context:transitionContext actions:^{
            toView.y=[self relateViewYToWindow]-toView.height;
        } animations:^{ toView.y=[self relateViewYToWindow]; }];
    }else if (_animateStyle==HGPopverAnimatorFromBottomStyle){
        [self fromView:toView context:transitionContext actions:^{
            toView.y=CGRectGetMaxY(toView.frame);
        } animations:^{ toView.y=[self relateViewYToWindow]+self.relateView.height-toView.height; }];
    }else if (_animateStyle==HGPopverAnimatorVerticalScaleStyle){
        toView.layer.anchorPoint=CGPointMake(0.5, 0);
        toView.transform=CGAffineTransformMakeScale(1.0, 0.0);
        [UIView animateWithDuration:_duration animations:^{ toView.transform=CGAffineTransformIdentity;
        } completion:^(BOOL finished) { [transitionContext completeTransition:YES];
        }];
    }else if (_animateStyle==HGPopverAnimatorHorizontalScaleStyle){
        toView.layer.anchorPoint=CGPointMake(0, 0.5);
        toView.transform=CGAffineTransformMakeScale(0.0,1.0);
        [UIView animateWithDuration:_duration animations:^{ toView.transform=CGAffineTransformIdentity;
        } completion:^(BOOL finished) { [transitionContext completeTransition:YES];
        }];
    }
}
// 方法抽取
- (void)fromView:(UIView *)view context:(id<UIViewControllerContextTransitioning>)transitionContext actions:(void(^)())actions animations:(void (^)(void))animations
{
    kWeakSelf;
    view.hidden=YES;
    actions();
    view.hidden=NO;
    __block UIView * coverView=[self getPresentationControllerCoverView];
    void (^endAnimations) (void)= ^ (void){
        animations();
        coverView.backgroundColor=weakSelf.backgroundColor;
    };
    [UIView animateWithDuration:weakSelf.duration animations:endAnimations completion:^(BOOL finished){
        [transitionContext completeTransition:YES];
    }];
}
// 方法抽取
- (void)toView:(UIView *)view context:(id<UIViewControllerContextTransitioning>)transitionContext animations:(void (^)(void))animations
{
    kWeakSelf;
    __block UIView * coverView=[self getPresentationControllerCoverView];
    void (^completeTransitionBlock) (BOOL) = ^(BOOL finished){
        [transitionContext completeTransition:YES];
    };
    [UIView animateWithDuration:weakSelf.duration animations:^{
        animations();
        coverView.backgroundColor=[UIColor clearColor];
    } completion:completeTransitionBlock];

}
static  CGRect addMinY (CGRect rect){
    CGRect tmp=rect;
    tmp.origin.y+=20;
    return tmp;
}
- (CGRect)relateViewToWindow
{
    return  [self.relateView convertRect:self.relateView.bounds toView:[[UIApplication sharedApplication] keyWindow]];
}
- (CGFloat)relateViewMaxXToWindow
{
    return  [self relateViewXToWindow]+_relateView.width;
}
- (CGFloat)relateViewMaxYToWindow
{
    return  [self relateViewYToWindow]+_relateView.height;
}

- (CGFloat)relateViewXToWindow
{
    return  [self relateViewToWindow].origin.x;
}
- (CGFloat)relateViewYToWindow
{
    return  [self relateViewToWindow].origin.y;
}
- (UIView *)getPresentationControllerCoverView
{
    return  [self getPresentationController].coverView;
}
- (HGPresentationController *)getPresentationController
{
    return  objc_getAssociatedObject(self, &HGPresentationControllerKey);
}
- (CGFloat)scaleDuration:(UIView *)view
{
    if (self.animateStyle==HGPopverAnimatorFromLeftStyle){
        return (self.presentFrame.size.width+self.presentFrame.origin.x-[self relateViewXToWindow])/view.width;
    }else if (self.animateStyle==HGPopverAnimatorFromRightStyle){
        return ([self relateViewMaxXToWindow]-view.x)/view.width;
    }else if(self.animateStyle==HGPopverAnimatorFromBottomStyle){
        return ([self relateViewMaxYToWindow]-self.presentFrame.origin.y)/view.height;
    }else if (self.animateStyle==HGPopverAnimatorFromTopStyle){
        return 1;
//        return (self.presentFrame.size.height+self.presentFrame.origin.y-[self relateViewMaxYToWindow])/view.height;
    }else if (self.animateStyle==HGPopverAnimatorHorizontalScaleStyle){
        return self.presentFrame.size.width/view.width;
    }else if (self.animateStyle==HGPopverAnimatorVerticalScaleStyle){
        return self.presentFrame.size.height/view.height;
    }else{
        return 1.0f;
    }
}
@end
