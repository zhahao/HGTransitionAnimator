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

static const CGFloat defaultVelocityX=100;
static const CGFloat defaultVelocityY=150;

@interface  HGPresentationController()
@property (nonatomic, assign) CGPoint currentTranslation; // 当前滑动位置
@property (nonatomic, assign) CGPoint currentVelocity; // 滑动速率
@property (nonatomic, strong) UIView *panView;
@property (nonatomic, assign) BOOL willPresent;
@end

@implementation HGPresentationController

- (UIView*)coverView
{
    if (!_coverView) {
        self.coverView = [[UIView alloc]init];
        self.coverView.backgroundColor=[UIColor clearColor];
        if (self.response) {
            [self.coverView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hg_close)]];
        }
    }
    return _coverView;
}

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController
{
    self.response=YES;
    return [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
}
- (void)presentationTransitionWillBegin
{
    self.willPresent=YES;
    [super presentationTransitionWillBegin];
}

- (void)containerViewWillLayoutSubviews
{
    self.coverView.frame=[UIScreen mainScreen].bounds;
    [self.containerView insertSubview:self.coverView atIndex:0];
    self.presentedView.frame=_presentFrame;
    
    
    if (self.willPresent&&(self.canPanTopOrBottom || self.canPanLeftOrRight)) {
        UIPanGestureRecognizer *panGestureRecognizer=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
        panGestureRecognizer.minimumNumberOfTouches = 1;
        panGestureRecognizer.maximumNumberOfTouches = 1;
        [self.containerView addGestureRecognizer:panGestureRecognizer];
    }
    
}
- (void)containerViewDidLayoutSubviews
{
    

}
- (void)hg_close
{
    if (self.canResponse){
        if ([self.hg_delegate respondsToSelector:@selector(coverViewWillDismiss:)]) {
            BOOL  animate=[self.hg_delegate coverViewWillDismiss:self.coverView];
            [self.presentedViewController hg_dismissViewControllerAnimated:animate completion:nil];
        }else{
            [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
        }
    }
}
- (void)handlePan:(UIPanGestureRecognizer*)recognizer
{

    CGPoint translation = [recognizer translationInView:self.containerView.superview];
    CGPoint velocity = [recognizer velocityInView:self.containerView.superview];
    CGFloat velocityX=velocity.x-self.currentVelocity.x;
    CGFloat velocityY=velocity.y-self.currentVelocity.y;
    
    CGFloat scale=0.3;
    if (self.canPanTopOrBottom) {
        CGFloat dy=translation.y-self.currentTranslation.y;
        if (dy>=self.presentedView.height) dy=0;
        self.presentedView.y+=dy;
        
        if (self.presentedView.y<-self.presentedView.height*(1+scale) || self.presentedView.y>CGRectGetMaxY(self.coverView.frame)*(1-scale)){
            [self.presentedViewController hg_dismissViewControllerAnimated:NO completion:nil];  return  ;
        }
    }
    
    if (self.canPanLeftOrRight) {
        CGFloat dx=translation.x-self.currentTranslation.x;
        if (ABS(dx)>=self.presentedView.width)   dx=0;
        self.presentedView.x+=dx;
    }
    
    if (_animateStyle ==HGTransitionAnimatorFromLeftStyle ) {
        
        if (self.presentedView.x>=0) { // 避免右边出边界
            self.presentedView.x=0;
        }
        if (velocityX<-defaultVelocityX){
            [self.presentedViewController hg_dismissViewControllerAnimated:YES completion:nil]; return;
        }
        
        if (<#condition#>) {
            <#statements#>
        }
        
        if (recognizer.state==UIGestureRecognizerStateEnded || recognizer.state==UIGestureRecognizerStateRecognized) { // 停止滚动,判断是否要保持当前状态还消失
            if (ABS(self.presentedView.x)>=self.presentedView.width*(1-scale)) {
                [self.presentedViewController hg_dismissViewControllerAnimated:YES completion:nil];
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
@end
