//
//  HGPresentationController.m
//  HGTransitionAnimator
//
//  Created by 查昊 on 16/5/23.
//  Copyright © 2016年 haocha. All rights reserved.
//

#import "HGPresentationController.h"
#import "UIViewController+HGAnimator.h"
#import "HGTransitionAnimatorDelegate.h"

static const CGFloat defaultVelocityX=300;
static const CGFloat scale=0.5;

@interface  HGPresentationController()

@property (nonatomic, assign) CGPoint currentTranslation; // 当前滑动位置
@property (nonatomic, assign) CGPoint currentVelocity; // 滑动速率
@property (nonatomic, assign) CGFloat alpha; // 滑动速率
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) HGTransitionAnimatorStyle animateStyle;
@property (nonatomic, assign) CGRect  presentFrame;// <- 记录当前的frame
@property (nonatomic, assign) BOOL    response;
@property (nonatomic, strong) UIView  *panView;
@property (nonatomic, strong) UIView  *coverView;
@property (nonatomic, strong) UIColor *backgroundColor;

@end

@implementation HGPresentationController

- (UIView*)coverView
{
    if (!_coverView) {
        self.coverView = [[UIView alloc]init];
        self.coverView.backgroundColor=[UIColor clearColor];
        if (self.response) {
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hg_close)];
            [self.coverView addGestureRecognizer:tap];
        }
    }
    return _coverView;
}
-(instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController
                      presentingViewController:(UIViewController *)presentingViewController
                               backgroundColor:(UIColor *)backgroundColor
                                  animateStyle:(HGTransitionAnimatorStyle)animateStyle
                                  presentFrame:(CGRect)presentFrame
                                      duration:(NSTimeInterval)duration
                                      response:(BOOL)response
{
    if (self=[super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController]) {
        SETTER(animateStyle);
        SETTER(presentFrame);
        SETTER(backgroundColor);
        SETTER(duration);
        SETTER(response);
        _alpha=CGColorGetAlpha(self.backgroundColor.CGColor);
    }
    return self;
}

-(void)presentationTransitionDidEnd:(BOOL)completed
{
    if (!_response)     return  ;
    UIPanGestureRecognizer *panGestureRecognizer=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    panGestureRecognizer.minimumNumberOfTouches = 1;
    panGestureRecognizer.maximumNumberOfTouches = 1;
    [self.containerView addGestureRecognizer:panGestureRecognizer];
    
    UISwipeGestureRecognizer *swipeGestureRecognizer=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipe:)];
    swipeGestureRecognizer.numberOfTouchesRequired=1;
    swipeGestureRecognizer.direction= 1 << _direction;
    [self.containerView addGestureRecognizer:swipeGestureRecognizer];
}

- (void)containerViewWillLayoutSubviews
{
    self.coverView.frame=[UIScreen mainScreen].bounds;
    [self.containerView insertSubview:self.coverView atIndex:0];
    self.presentedView.frame=_presentFrame;
}

- (void)hg_close
{
    if (_response){
        if ([self.hg_delegate respondsToSelector:@selector(presentedViewBeginDismiss:)]) {
            BOOL  animate=[self.hg_delegate presentedViewBeginDismiss:_duration];
            [self.presentedViewController hg_dismissViewControllerAnimated:animate completion:nil];
        }else{
            [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (void)handleSwipe:(UISwipeGestureRecognizer*)recognizer
{
    [self.presentedViewController hg_dismissViewControllerAnimated:YES completion:nil];
}

- (void)handlePan:(UIPanGestureRecognizer*)recognizer
{
    
    self.coverView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:(1-ABS(self.presentedView.x)/self.presentedView.width)*_alpha]; // 根据拖动情况改变背景色
    
    CGPoint translation = [recognizer translationInView:self.containerView.superview];
    CGPoint velocity = [recognizer velocityInView:self.containerView.superview];
    CGFloat velocityX=velocity.x-self.currentVelocity.x;
    
    if (self.direction) {
        CGFloat dx=translation.x-self.currentTranslation.x; //累加偏移值
        if (ABS(dx)>=self.presentedView.width)   dx=0;      //防止左边出界
        self.presentedView.x+=dx;
    }
    
    if (_animateStyle ==HGTransitionAnimatorFromLeftStyle ) {
        
        if (self.presentedView.x>=0) { // 避免右边出边界
            self.presentedView.x=0;
        }
        
        if (velocityX<-defaultVelocityX){
            [self.presentedViewController hg_dismissViewControllerAnimated:YES completion:nil]; return;
        }
        
        if (recognizer.state==UIGestureRecognizerStateEnded || recognizer.state==UIGestureRecognizerStateRecognized) { // 停止滚动,判断是否要保持当前状态还消失
            if (ABS(self.presentedView.x)>=self.presentedView.width*(1-scale)) {
                [self.presentedViewController hg_dismissViewControllerAnimated:YES completion:nil];
            }
            
            if (CGRectGetMaxX(self.presentedView.frame) >=self.presentedView.width*(1-scale)) {// 右弹效果
                [UIView animateWithDuration:0.15 animations:^{
                    self.presentedView.x=0;
                    self.coverView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
                }];
            }
            
            self.currentVelocity=CGPointZero;
            self.currentTranslation=CGPointZero;    //只要停止就要清空已经记录的偏移
            return  ;
        }
    }
    
    if (_animateStyle ==HGTransitionAnimatorFromRightStyle) {
        if (self.presentedView.x<=self.coverView.width-self.presentedView.width) {
            self.presentedView.x=self.coverView.width-self.presentedView.width;
        }
        if (recognizer.state==UIGestureRecognizerStateEnded&&self.presentedView.x>=self.coverView.width*(1-scale)) {
            [self.presentedViewController hg_dismissViewControllerAnimated:NO completion:nil];
        }
    }
    
    self.currentTranslation=translation;
    self.currentVelocity=velocity;
}

- (void)leftOrRigthRecognizerWithVelocityX:(CGFloat )velocityX dx:(CGFloat )dx
{
    //    if (self.canPanTopOrBottom) {
    //        CGFloat dy=translation.y-self.currentTranslation.y;
    //        if (dy>=self.presentedView.height) dy=0;
    //        self.presentedView.y+=dy;
    //
    //        if (self.presentedView.y<-self.presentedView.height*(1+scale) || self.presentedView.y>CGRectGetMaxY(self.coverView.frame)*(1-scale)){
    //            [self.presentedViewController hg_dismissViewControllerAnimated:NO completion:nil];  return  ;
    //        }
    //    }

}

@end



