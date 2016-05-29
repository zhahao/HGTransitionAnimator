//
//  HGTransitioningDelegate.m
//  自定义转场动画_OC
//
//  Created by 查昊 on 16/5/23.
//  Copyright © 2016年 haocha. All rights reserved.
//

#import "HGTransitionAnimator.h"
#import "HGPresentationController.h"
#import <objc/runtime.h>

#define SETTER(hg_property) _##hg_property=(hg_property)

#ifndef HGWeakSelf
    #define HGWeakSelf __weak __typeof(self)weakSelf = self;
#endif

@interface UIView (HGExtension)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@end

const NSTimeInterval defaultDuratin=0.52;

@interface  HGTransitionAnimator()
@property (nonatomic, weak)   UIView *relateView;//<-参照的View
@property (nonatomic, assign) BOOL  willPresent;//<- 即将展示
@property (nonatomic, assign) BOOL animated;//<- 是否动画
@property (nonatomic, assign) CGRect presentFrame;//<- 弹出视图的的frame
@property (nonatomic, assign) HGTransitionAnimatorStyle animateStyle;//<- push样式
@property (nonatomic, assign) NSTimeInterval duration;//<- 动画时间
@property (nonatomic, strong) UIColor *backgroundColor;//<- 蒙版背景色
@property (nonatomic, assign,nullable) id<HGTransitionAnimatorDelegate> delegate;//<- 代理
@end

static NSString *const HGPresentationControllerKey=@"HGPresentationControllerKey";
@implementation HGTransitionAnimator

-(instancetype)initWithAnimateStyle:(HGTransitionAnimatorStyle)animateStyle relateView:(UIView *)relateView presentFrame:(CGRect)presentFrame backgroundColor:(UIColor *)backgroundColor delegate:(id<HGTransitionAnimatorDelegate>)delegate animated:(BOOL)animated
{
    if (self=[super init]) {
        SETTER(animateStyle);
        SETTER(relateView);
        SETTER(presentFrame);
        SETTER(delegate);
        SETTER(animated);
        _duration=_animated ? defaultDuratin:0;
        _backgroundColor=backgroundColor==nil ? [UIColor clearColor]:backgroundColor;
    }
    return self;
}

-(UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    HGPresentationController *presentController=nil;
    if ([self getPresentationController]) {
        presentController=[self getPresentationController];
    }else{
        presentController=[[HGPresentationController alloc]initWithPresentedViewController:presented presentingViewController:presenting];
        presentController.presentFrame=self.presentFrame;
        if (self.delegate&&[self.delegate respondsToSelector:@selector(transitionAnimatorCanResponse:)]) {
            presentController.response=[self.delegate transitionAnimatorCanResponse:self];
        }
        objc_setAssociatedObject(self, &HGPresentationControllerKey, presentController, OBJC_ASSOCIATION_ASSIGN);
    }
    return presentController;

}
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.willPresent=YES;
    if (_delegate&&[_delegate respondsToSelector:@selector(transitionAnimator:animationControllerForPresentedController:)]) {
        [self.delegate transitionAnimator:self animationControllerForPresentedController:source];
    }
    return self;
}
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.willPresent=NO;
    if (_delegate&&[_delegate respondsToSelector:@selector(transitionAnimator:animationControllerForDismissedController:)]) {
        [self.delegate transitionAnimator:self animationControllerForDismissedController:dismissed];
    }
    return self;
}
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if(self.delegate&&_animateStyle==HGTransitionAnimatorCustomStyle&&[self.delegate respondsToSelector:@selector(transitionDuration:)]){
        _duration=[self.delegate transitionDuration:self];
       };
    return _duration;
}
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *coverView=[self getPresentationControllerCoverView];
    if (_willPresent) {
         UIView *toView=[transitionContext viewForKey:UITransitionContextToViewKey];
        [[transitionContext containerView] addSubview:toView];
        if (_animateStyle==HGTransitionAnimatorCustomStyle) { // 自定义
            NSAssert(self.delegate&&[self.delegate respondsToSelector:@selector(transitionAnimator:animateTransitionToView:duration:)], @"自定义样式必须实现transitionAnimator:animateTransitionToView:duration:代理方法!");
            [self.delegate transitionAnimator:self animateTransitionToView:toView duration:_duration];
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
        if (_animateStyle==HGTransitionAnimatorCustomStyle) { // 自定义
            NSAssert(self.delegate&&[self.delegate respondsToSelector:@selector(transitionAnimator:animateTransitionFromView:duration:)], @"自定义样式必须实现transitionAnimator:animateTransitionFromView:duration:代理方法!");
                [_delegate transitionAnimator:self animateTransitionFromView:fromView duration:_duration];
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
    HGWeakSelf;
    if (_animateStyle==HGTransitionAnimatorFromLeftStyle) {
        [self fromView:fromView context:transitionContext animations:^{
            fromView.x=[self relateViewXToWindow]-fromView.width; }];
    }else if (_animateStyle==HGTransitionAnimatorFromRightStyle){
        [self fromView:fromView context:transitionContext animations:^{
            fromView.x=[self relateViewXToWindow]+weakSelf.relateView.width; }];
    }else if (_animateStyle==HGTransitionAnimatorFromTopStyle){
        [self fromView:fromView context:transitionContext animations:^{
            fromView.y=[self relateViewXToWindow]-fromView.height; }];
    }else if (_animateStyle==HGTransitionAnimatorFromBottomStyle){
        [self fromView:fromView context:transitionContext animations:^{
            fromView.y=[self relateViewYToWindow]+weakSelf.relateView.height+fromView.height; }];
    }else if (_animateStyle==HGTransitionAnimatorHiddenStyle){
        [self fromView:fromView context:transitionContext animations:^{ fromView.alpha=0.0f; }];
    }else if (_animateStyle==HGTransitionAnimatorVerticalScaleStyle){
        [self fromView:fromView context:transitionContext animations:^{
            fromView.transform=CGAffineTransformMakeScale(1.0, 0.000001); }];
    }else if (_animateStyle==HGTransitionAnimatorHorizontalScaleStyle){
        [self fromView:fromView context:transitionContext animations:^{
            fromView.transform=CGAffineTransformMakeScale(0.000001, 1.0); }];
    }else{
        [self fromView:fromView context:transitionContext animations:^{
            fromView.transform=CGAffineTransformMakeScale(0.000001, 0.000001); }];
    }
}
// push
- (void)setupPushAnimator:(UIView *)toView context:(id<UIViewControllerContextTransitioning>)transitionContext coverView:(UIView *)coverView
{
    HGWeakSelf;
    if (_animateStyle==HGTransitionAnimatorFromLeftStyle) {
        [self toView:toView context:transitionContext actions:^{
            toView.x=[weakSelf relateViewXToWindow]-toView.width;
        } animations:^{ toView.x=[weakSelf relateViewXToWindow]; }];
    }else if (_animateStyle==HGTransitionAnimatorFromRightStyle){
        [self toView:toView context:transitionContext actions:^{
            toView.x=[self relateViewXToWindow]+toView.width;
        } animations:^{ toView.x=[self relateViewXToWindow]+self.relateView.width-toView.width; }];
    }else if (_animateStyle==HGTransitionAnimatorFromTopStyle){
        [self toView:toView context:transitionContext actions:^{
            toView.y=[self relateViewYToWindow]-toView.height;
        } animations:^{ toView.y=[self relateViewYToWindow]; }];
    }else if (_animateStyle==HGTransitionAnimatorFromBottomStyle){
        [self toView:toView context:transitionContext actions:^{
            toView.y=CGRectGetMaxY(toView.frame);
        } animations:^{ toView.y=[self relateViewYToWindow]+self.relateView.height-toView.height; }];
    }else if (_animateStyle==HGTransitionAnimatorHiddenStyle){
        [self toView:toView context:transitionContext actions:nil animations:^{ toView.alpha=1.0f; }];
    }else{
        CGPoint anchorPoint;
        CGAffineTransform CGAffineTransformScale;
        if (_animateStyle==HGTransitionAnimatorVerticalScaleStyle){
            anchorPoint=CGPointMake(0.5, 0);
            CGAffineTransformScale=CGAffineTransformMakeScale(1.0, 0.0);
        }else if (_animateStyle==HGTransitionAnimatorHorizontalScaleStyle){
            anchorPoint=CGPointMake(0, 0.5);
            CGAffineTransformScale=CGAffineTransformMakeScale(0.0, 1.0);
        }else if (_animateStyle==HGTransitionAnimatorFocusTopRightStyle){
            anchorPoint=CGPointMake(1, 0);
            CGAffineTransformScale=CGAffineTransformMakeScale(0.0, 0.0);
        }else if (_animateStyle==HGTransitionAnimatorFocusTopCenterStyle){
            anchorPoint=CGPointMake(0.5, 0);
            CGAffineTransformScale=CGAffineTransformMakeScale(0.0, 0.0);
        }else if (_animateStyle==HGTransitionAnimatorFocusTopLeftStyle){
            anchorPoint=CGPointMake(0, 0);
            CGAffineTransformScale=CGAffineTransformMakeScale(0.0, 0.0);
        }
        toView.layer.anchorPoint=anchorPoint;
        toView.transform=CGAffineTransformScale;
        [UIView animateWithDuration:_duration animations:^{
            toView.transform=CGAffineTransformIdentity;
            [self getPresentationControllerCoverView].backgroundColor=weakSelf.backgroundColor;
        } completion:^(BOOL finished) { [transitionContext completeTransition:YES]; }];
    }
}
// 方法抽取
- (void)toView:(UIView *)view context:(id<UIViewControllerContextTransitioning>)transitionContext actions:(void(^)())actions animations:(void (^)(void))animations
{
    HGWeakSelf;
    if (actions){
        view.hidden=YES;
        actions();
        view.hidden=NO;
    }else{
        view.alpha=0.0f;
    }
    
    __block UIView * coverView=[self getPresentationControllerCoverView];
    void (^endAnimations) (void)= ^ (void){
        if (animations) animations();
        coverView.backgroundColor=weakSelf.backgroundColor;
    };
    [UIView animateWithDuration:weakSelf.duration animations:endAnimations completion:^(BOOL finished){
        [transitionContext completeTransition:YES];
    }];
}
// 方法抽取
- (void)fromView:(UIView *)view context:(id<UIViewControllerContextTransitioning>)transitionContext animations:(void (^)(void))animations
{
    HGWeakSelf;
    __block UIView * coverView=[self getPresentationControllerCoverView];
    void (^completeTransitionBlock) (BOOL) = ^(BOOL finished){ [transitionContext completeTransition:YES]; };
    [UIView animateWithDuration:weakSelf.duration animations:^{
        animations();
        coverView.backgroundColor=[UIColor clearColor];
    } completion:completeTransitionBlock];
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
    CGFloat x=self.presentFrame.origin.x;
    CGFloat y=self.presentFrame.origin.y;
    CGFloat width=self.presentFrame.size.width;
    CGFloat height=self.presentFrame.size.height;
    
    if (self.animateStyle==HGTransitionAnimatorFromLeftStyle){
        return (width+x-[self relateViewXToWindow])/view.width;
    }else if (self.animateStyle==HGTransitionAnimatorFromRightStyle){
        return ([self relateViewMaxXToWindow]-view.x)/view.width;
    }else if(self.animateStyle==HGTransitionAnimatorFromBottomStyle){
        return ([self relateViewMaxYToWindow]-y)/view.height;
    }else if (self.animateStyle==HGTransitionAnimatorFromTopStyle){
        return (height+y-[self relateViewMaxYToWindow])/view.height;
    }else if (self.animateStyle==HGTransitionAnimatorHorizontalScaleStyle){
        return width/view.width;
    }else if (self.animateStyle==HGTransitionAnimatorVerticalScaleStyle){
        return height/view.height;
    }else{
        return 1.0f;
    }
}
@end
@implementation UIView (HGExtension)

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)width
{
    return self.frame.size.width;
}
@end