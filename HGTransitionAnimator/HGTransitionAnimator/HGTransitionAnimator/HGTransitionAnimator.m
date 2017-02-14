//
//  HGTransitioningDelegate.m
//  HGTransitionAnimator
//
//  Created by 查昊 on 16/5/23.
//  Copyright © 2016年 haocha. All rights reserved.
//

#import "HGTransitionAnimator.h"
#import "HGPresentationController.h"
#import "UIView+HGExtension.h"
#import <objc/runtime.h>


static char HGPresentationControllerKey;
const  NSTimeInterval kHGAnimatorDuration = 0.52;

@interface  HGTransitionAnimator()

@property (nonatomic, weak)   UIView *relateView;//<-参照的View
@property (nonatomic, assign) BOOL  willPresent;//<- 即将展示
@property (nonatomic, assign) BOOL animated;//<- 是否动画
@property (nonatomic, assign) CGRect presentFrame;//<- 弹出视图的的frame
@property (nonatomic, assign) HGTransitionAnimatorStyle animateStyle;//<- 动画样式
@property (nonatomic, assign) NSTimeInterval duration;//<- 动画时间
@property (nonatomic, strong) UIColor *backgroundColor;//<- 蒙版背景色
@property (nonatomic, strong, readonly) UIView *presentationControllerCoverView;//<- 背景视图
@property (nonatomic, assign, nullable) id <HGTransitionAnimatorDelegate> delegate;//<- 代理

// 内部方法声明
- (CGFloat)relateViewMaxXToWindow;

- (CGFloat)relateViewMaxYToWindow;

- (CGFloat)relateViewXToWindow;

- (CGFloat)relateViewYToWindow;

- (CGFloat)relateViewWidthToWindow;

@end

@implementation HGTransitionAnimator

-(instancetype)initWithAnimateStyle:(HGTransitionAnimatorStyle)animateStyle
                         relateView:(UIView *)relateView
                       presentFrame:(CGRect)presentFrame
                    backgroundColor:(UIColor *)backgroundColor
                           delegate:(id<HGTransitionAnimatorDelegate>)delegate
                           animated:(BOOL)animated
{
    self = [super init];
    if (!self) return nil;

    _animateStyle = animateStyle;
    _relateView = relateView;
    _presentFrame = presentFrame;
    _delegate = delegate;
    _animated = animated;
    _duration = _animated ? kHGAnimatorDuration: 0;
    _backgroundColor = backgroundColor ?: [UIColor clearColor];

    return self;
}

-(UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented
                                                     presentingViewController:(UIViewController *)presenting
                                                         sourceViewController:(UIViewController *)source
{
    
    BOOL response = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(transitionAnimatorCanResponse:)]) {
        response = [self.delegate transitionAnimatorCanResponse:self];
    }
    HGPresentationController *presentController =
    [[HGPresentationController alloc] initWithPresentedViewController:presented
                                             presentingViewController:presenting
                                                      backgroundColor:_backgroundColor
                                                         animateStyle:_animateStyle
                                                         presentFrame:_presentFrame
                                                             duration:_duration
                                                             response:response];
    
    objc_setAssociatedObject(self, &HGPresentationControllerKey, presentController,OBJC_ASSOCIATION_ASSIGN);
    return presentController;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                 presentingController:(UIViewController *)presenting
                                                                     sourceController:(UIViewController *)source
{
    self.willPresent = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(transitionAnimator:animationControllerForPresentedController:)]) {
        [self.delegate transitionAnimator:self animationControllerForPresentedController:source];
    }
    return self;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.willPresent = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(transitionAnimator:animationControllerForDismissedController:)]) {
        [self.delegate transitionAnimator:self animationControllerForDismissedController:dismissed];
    }
    return self;
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(transitionDuration:)]){
        _duration = _animated ? [self.delegate transitionDuration:self] : 0;
       };
    return _duration;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *coverView = self.presentationControllerCoverView;
    if (_willPresent) {
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        [[transitionContext containerView] addSubview:toView];
        if (_animateStyle == HGTransitionAnimatorCustomStyle) { // 自定义
            [self.delegate transitionAnimator:self animateTransitionToView:toView duration:_duration];
            [UIView animateWithDuration:_duration animations:^{
                coverView.backgroundColor = _backgroundColor;
            } completion:^(BOOL finished) {
                [transitionContext completeTransition:YES];
            }];

        }else{
            [self setupPushAnimator:toView context:transitionContext coverView:coverView];
        }
    }else{

        UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        if (_animateStyle == HGTransitionAnimatorCustomStyle) { // 自定义
            [self.delegate transitionAnimator:self animateTransitionFromView:fromView duration:_duration];
            [UIView animateWithDuration:_duration animations:^{
                coverView.backgroundColor = [UIColor clearColor];
            } completion:^(BOOL finished) {
                [transitionContext completeTransition:YES];
            }];
        }else{
            [self setupPopAnimator:fromView context:transitionContext coverView:coverView];
        }
    }
}

- (void)setupPopAnimator:(UIView *)fromView context:(id<UIViewControllerContextTransitioning>)transitionContext coverView:(UIView *)coverView
{

#define UPDATE_ANIMATE(...)\
[self fromView:fromView context:transitionContext animations:^{\
    __VA_ARGS__;\
}];\

    switch (_animateStyle) {
        case HGTransitionAnimatorFromLeftStyle:{
            UPDATE_ANIMATE(fromView.x = self.relateViewXToWindow - fromView.width)
        }break;
        case HGTransitionAnimatorFromRightStyle:{
            UPDATE_ANIMATE(fromView.x = self.relateViewXToWindow + self.relateView.width)
        }break;
        case HGTransitionAnimatorFromTopStyle:{
            UPDATE_ANIMATE(fromView.y = self.relateViewXToWindow - fromView.height)
        }break;
        case HGTransitionAnimatorFromBottomStyle:{
            UPDATE_ANIMATE(fromView.y = self.relateViewYToWindow + self.relateView.height + fromView.height)
        }break;
        case HGTransitionAnimatorHiddenStyle:{
            UPDATE_ANIMATE(fromView.alpha = 0.0f)
        }break;
        case HGTransitionAnimatorVerticalScaleStyle:{
            UPDATE_ANIMATE(fromView.transform = CGAffineTransformMakeScale(1.0, 0.000001))
        }break;
        case HGTransitionAnimatorHorizontalScaleStyle:{
            UPDATE_ANIMATE(fromView.transform = CGAffineTransformMakeScale(0.000001, 1.0));
        }break;
        case HGTransitionAnimatorCenterStyle:{
            UPDATE_ANIMATE(fromView.transform = CGAffineTransformMakeScale(0.000001, 0.000001))
        }break;
        default: break;
    }
#undef UPDATE_ANIMATE

}

- (void)setupPushAnimator:(UIView *)toView context:(id<UIViewControllerContextTransitioning>)transitionContext coverView:(UIView *)coverView
{
    if (_animateStyle == HGTransitionAnimatorFromLeftStyle) {
        [self toView:toView context:transitionContext actions:^{
            toView.x = self.relateViewXToWindow - toView.width;
        } animations:^{
            toView.x = self.relateViewXToWindow;
        }];
    }else if (_animateStyle == HGTransitionAnimatorFromTopStyle){
        [self toView:toView context:transitionContext actions:^{
            toView.y = self.relateViewYToWindow - toView.height;
        } animations:^{
            toView.y = self.relateViewYToWindow;
        }];
    }else if (_animateStyle == HGTransitionAnimatorFromRightStyle){
        [self toView:toView context:transitionContext actions:^{
            toView.x = self.relateViewXToWindow + self.relateViewWidthToWindow + toView.width;
        } animations:^{
            toView.x = self.relateViewXToWindow + self.relateView.width - toView.width;
        }];
    }else if (_animateStyle == HGTransitionAnimatorFromBottomStyle){
        [self toView:toView context:transitionContext actions:^{
            toView.y = CGRectGetMaxY(toView.frame);
        } animations:^{
            toView.y = self.relateViewYToWindow + self.relateView.height - toView.height;
        }];
    }else if (_animateStyle == HGTransitionAnimatorHiddenStyle){
        [self toView:toView context:transitionContext actions:NULL animations:^{
            toView.alpha = 1.0f;
        }];
    }else{
        CGPoint anchorPoint = CGPointZero;
        CGAffineTransform CGAffineTransformScale = CGAffineTransformMakeScale(0, 0);

#define UPDATE_POINT(_x1_,_y1_,_x2_,_y2_)\
anchorPoint = CGPointMake(_x1_, _y1_);\
CGAffineTransformScale = CGAffineTransformMakeScale(_x2_, _y2_);\

        switch (_animateStyle) {
            case HGTransitionAnimatorVerticalScaleStyle:{
                UPDATE_POINT(0.5, 0.0, 1.0, 0.0)
            }break;
            case HGTransitionAnimatorHorizontalScaleStyle:{
                UPDATE_POINT(0.0, 0.5, 0.0, 1.0)
            }break;
            case HGTransitionAnimatorCenterStyle:{
                UPDATE_POINT(0.5, 0.5, 0.0, 0.0)
            }break;
            case HGTransitionAnimatorFocusTopRightStyle:{
                UPDATE_POINT(1.0, 0.0, 0.0, 0.0)
            }break;
            case HGTransitionAnimatorFocusTopCenterStyle:{
                UPDATE_POINT(0.5, 0.0, 0.0, 0.0)
            }break;
            case HGTransitionAnimatorFocusTopLeftStyle:{
                UPDATE_POINT(0.0, 0.0, 0.0, 0.0)
            }break;
            default: break;
        }
        
#undef UPDATE_POINT
        toView.layer.anchorPoint = anchorPoint;
        toView.transform = CGAffineTransformScale;

        [UIView animateWithDuration:_duration animations:^{
            toView.transform = CGAffineTransformIdentity;
            self.presentationControllerCoverView.backgroundColor = self.backgroundColor;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}

// 方法抽取
- (void)toView:(UIView *)view context:(id<UIViewControllerContextTransitioning>)transitionContext actions:(void(^)())actions animations:(void (^)(void))animations
{
    if (actions){
        view.hidden = YES;
        actions();
        view.hidden = NO;
    }else{
        view.alpha = 0.0f;
    }
    
    [UIView animateWithDuration:self.duration animations:^{
        if (animations) animations();
        self.presentationControllerCoverView.backgroundColor = self.backgroundColor;
    } completion:^(BOOL finished){
        [transitionContext completeTransition:YES];
    }];
}

// 方法抽取
- (void)fromView:(UIView *)view context:(id<UIViewControllerContextTransitioning>)transitionContext animations:(void (^)(void))animations
{
    [UIView animateWithDuration:self.duration animations:^{
        if (animations) animations();
        self.presentationControllerCoverView.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

- (CGRect)relateViewToWindow
{
    return  [self.relateView convertRect:self.relateView.bounds toView:[[[UIApplication sharedApplication] windows] firstObject]];
}

- (HGPresentationController *)presentationController
{
    return  objc_getAssociatedObject(self, &HGPresentationControllerKey);
}

- (CGFloat)relateViewMaxXToWindow
{
    return  [self relateViewXToWindow] + _relateView.width;
}

- (CGFloat)relateViewMaxYToWindow
{
    return  [self relateViewYToWindow] + _relateView.height;
}

- (CGFloat)relateViewXToWindow
{
    return  [self relateViewToWindow].origin.x;
}

- (CGFloat)relateViewYToWindow
{
    return  [self relateViewToWindow].origin.y;
}

- (CGFloat)relateViewWidthToWindow
{
    return  [self relateViewToWindow].size.width;
}

- (UIView *)presentationControllerCoverView
{
    return  self.presentationController.coverView;
}

@end

