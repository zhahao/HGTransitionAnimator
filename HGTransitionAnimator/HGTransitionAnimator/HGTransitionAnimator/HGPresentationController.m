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

@interface  HGPresentationController()
@property (nonatomic, assign) CGRect showFrame;
@property (nonatomic, assign,getter=canPanLeftOrRight) BOOL panLeftOrRight;
@property (nonatomic, assign,getter=canPanTopOrBottom) BOOL panTopOrBottom;
@property (nonatomic, assign) CGPoint currentTranslation;
@end

@implementation HGPresentationController

-(CGRect)showFrame
{
    return self.presentFrame;
}

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
    self.panLeftOrRight =NO;
    self.panTopOrBottom =NO;
    return [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
}

- (void)containerViewWillLayoutSubviews
{
    self.coverView.frame=[UIScreen mainScreen].bounds;
    [self.containerView insertSubview:self.coverView atIndex:0];
    if (CGRectEqualToRect(_presentFrame, CGRectZero)) {
        self.presentedView.frame=self.showFrame;
    }else{
        self.presentedView.frame=_presentFrame;
        if ([self.hg_delegate respondsToSelector:@selector(presentationControllerCanPanLeftOrRight:)]) {
            self.panLeftOrRight =[self.hg_delegate presentationControllerCanPanLeftOrRight:self];
        }
        
        if ([self.hg_delegate respondsToSelector:@selector(presentationControllerCanPanTopOrBottom:)]) {
            self.panTopOrBottom =[self.hg_delegate presentationControllerCanPanTopOrBottom:self];
        }
        if (self.canPanTopOrBottom || self.canPanLeftOrRight) {
            UIPanGestureRecognizer *panGestureRecognizer=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
            panGestureRecognizer.minimumNumberOfTouches = 1;
            panGestureRecognizer.maximumNumberOfTouches = 1;
            [self.coverView addGestureRecognizer:panGestureRecognizer];
//            [self.presentedView addGestureRecognizer:panGestureRecognizer];
        }
    }
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
//    CGPoint translation=CGPointZero;
//    if ([recognizer.view isEqual:self.presentedView]) {
//        
//        translation = [recognizer translationInView:self.presentedView.superview];
//    }else
//    {
//        translation = [recognizer translationInView:self.coverView.superview];
//    }
    CGPoint translation = [recognizer translationInView:self.coverView.superview];
    
    
//    NSLog(@"translation==%@",NSStringFromCGPoint(translation));
    
    if (recognizer.state==UIGestureRecognizerStateEnded) {
        [self.presentedViewController hg_dismissViewControllerAnimated:NO completion:nil];  return  ;
    }
    
    if (self.presentedView.x>=self.presentedView.width) {
        self.presentedView.x=self.presentedView.width;
    }
    
//    if (self.presentedView.x<=self.presentedView.width) {
//        self.presentedView.x=self.presentedView.width;
//    }
    
    if (self.canPanTopOrBottom) {
        CGFloat dy=translation.y-self.currentTranslation.y;
        if (dy>=self.presentedView.height) dy=0;
        self.presentedView.y+=dy;
        
        if (self.presentedView.y<-self.presentedView.height+5 || self.presentedView.y>CGRectGetMaxY(self.coverView.frame)-5){
            [self.presentedViewController hg_dismissViewControllerAnimated:NO completion:nil];  return  ;
        }
    }
    
    if (self.canPanLeftOrRight) {
        
        CGFloat dx=translation.x-self.currentTranslation.x;
        if (ABS(dx)>=self.presentedView.width)   dx=0;
        
        self.presentedView.x+=dx;
        if (self.presentedView.x<-self.presentedView.width+5 || self.presentedView.x>CGRectGetMaxX(self.coverView.frame)-5){
            [self.presentedViewController hg_dismissViewControllerAnimated:NO completion:nil];  return   ;
        }
    }
    self.currentTranslation=translation;
    
    
    
//    self.presentedView.center = CGPointMake(recognizer.view.center.x + translation.x,
//                                         recognizer.view.center.y + translation.y);
//    [recognizer setTranslation:CGPointZero inView:self.coverView.superview];
//    
//    if (recognizer.state == UIGestureRecognizerStateEnded) {
//        
//        CGPoint velocity = [recognizer velocityInView:self.coverView.superview];
//        CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
//        CGFloat slideMult = magnitude / 200;
//        NSLog(@"magnitude: %f, slideMult: %f", magnitude, slideMult);
//        
//        float slideFactor = 0.1 * slideMult;
//        CGPoint finalPoint = CGPointMake(self.presentedView.center.x + (velocity.x * slideFactor),
//                                         self.presentedView.center.y + (velocity.y * slideFactor));
//        finalPoint.x = MIN(MAX(finalPoint.x, 0), self.coverView.superview.bounds.size.width);
//        finalPoint.y = MIN(MAX(finalPoint.y, 0), self.coverView.superview.bounds.size.height);
//        
//        [UIView animateWithDuration:slideFactor*2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//            self.presentedView.center = finalPoint;
//        } completion:nil];
//        
//    }
}

-(void)dealloc
{
    NSLog(@"%s",__func__);
}

@end
