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
#import "UIView+HGExtension.h"

static const CGFloat kVelocityX = 500; // 水平滑动速度阈值
static const CGFloat kVelocityY = 250; // 垂直滑动速度阈值
static const CGFloat kScale = 0.5;     // 滑动阈值节点比例

@interface  HGPresentationController()

@property (nonatomic, assign) CGPoint currentTranslation; ///<- 当前滑动位置
@property (nonatomic, assign) CGPoint currentVelocity; ///<- 滑动速率
@property (nonatomic, assign) NSTimeInterval duration;///<- 动画时间
@property (nonatomic, assign) HGTransitionAnimatorStyle animateStyle;///<- 动画类型
@property (nonatomic, assign) CGRect  presentFrame;///<- 记录当前的frame
@property (nonatomic, assign) BOOL    response;///<- 背景是否响应手势
@property (nonatomic, strong) UIColor *backgroundColor;///<- 背景色


@end

@implementation HGPresentationController


- (UIView *)coverView
{
    if (!_coverView) {
        _coverView = [[UIView alloc]init];
        _coverView.backgroundColor = [UIColor clearColor];
        if (_response) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hg_close)];
            [_coverView addGestureRecognizer:tap];
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
    if (self = [super initWithPresentedViewController:presentedViewController
                             presentingViewController:presentingViewController])
    {
        _animateStyle = animateStyle;
        _presentFrame = presentFrame;
        _backgroundColor = backgroundColor;
        _duration = duration;
        _response = response;
        
    }
    return self;
}

-(void)presentationTransitionDidEnd:(BOOL)completed
{
    if (!_response || !_dragable) return;
    if (   _animateStyle == HGTransitionAnimatorFromTopStyle
        || _animateStyle == HGTransitionAnimatorFromLeftStyle
        || _animateStyle == HGTransitionAnimatorFromBottomStyle)
    {
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
        panGestureRecognizer.minimumNumberOfTouches = 1;
        panGestureRecognizer.maximumNumberOfTouches = 1;
        [self.containerView addGestureRecognizer:panGestureRecognizer];
    }
}

- (void)containerViewWillLayoutSubviews
{
    if (_duration == 0) self.coverView.backgroundColor = _backgroundColor;
    self.coverView.frame = [UIScreen mainScreen].bounds;
    [self.containerView insertSubview:self.coverView atIndex:0];
    self.presentedView.frame = _presentFrame;
}

- (void)hg_close
{
    if (!_response) return;
    if ([self.hg_delegate respondsToSelector:@selector(presentedViewBeginDismiss:)]) {
          BOOL animate = [self.hg_delegate presentedViewBeginDismiss:_duration];
          [self.presentedViewController hg_dismissViewControllerAnimated:animate completion:nil];
    }else [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)handlePan:(UIPanGestureRecognizer*)recognizer
{
    CGFloat r = 0, g = 0, b = 0, a = 0;
    [_backgroundColor getRed:&r green:&g blue:&b alpha:&a];
    CGFloat alpha = (1 - ABS(self.presentedView.x) / self.presentedView.width) * a;
    self.coverView.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:alpha]; // 根据拖动情况改变背景色
    
    CGPoint translation = [recognizer translationInView:self.containerView.superview];
    CGPoint v = [recognizer velocityInView:self.containerView.superview];
    CGFloat vx = v.x - self.currentVelocity.x;
    CGFloat vy = v.y - self.currentVelocity.y;

    if (_animateStyle == HGTransitionAnimatorFromLeftStyle ) {
        CGFloat dx = translation.x - self.currentTranslation.x;     //累加偏移值
        if (ABS(dx) >= self.presentedView.width) dx = 0;          //防止左边出界
        self.presentedView.x += dx;
        if (self.presentedView.x >= 0) self.presentedView.x = 0; //防止右边出边界
        
        if (vx < -kVelocityX && translation.x < 0){ // 快速滑动时
            [recognizer removeTarget:self action:@selector(handlePan:)];
            [self animateWithDuration:0.32 animations:^{
                self.presentedView.x = -self.presentedView.width;
                self.coverView.backgroundColor = [UIColor clearColor];
            } completionDismiss:YES];
            return  ;
        }

        if (recognizer.state == UIGestureRecognizerStateEnded) {
            // 停止滚动,判断是否要保持当前状态还消失
            if (ABS(self.presentedView.x) >= self.presentedView.width * (1 - kScale)) { // 左弹效果
                [self animateWithDuration:0.15 animations:^{
                    self.presentedView.x = -self.presentedView.width;
                    self.coverView.backgroundColor = [UIColor clearColor];
                } completionDismiss:YES];
            }
            
            if (CGRectGetMaxX(self.presentedView.frame) >= self.presentedView.width * (1 - kScale)) {// 右弹效果
                [self animateWithDuration:0.15 animations:^{
                    self.presentedView.x = 0;
                    self.coverView.backgroundColor = _backgroundColor;
                } completionDismiss:NO];
            }
            // 每次停止,需要清空记录
            self.currentVelocity = CGPointZero;
            self.currentTranslation = CGPointZero;
            return;
        }
    }
    
    if (_animateStyle == HGTransitionAnimatorFromTopStyle) {  // 从顶部出来的样式
        if (vy < -kVelocityY && v.y < 0) {
            [recognizer removeTarget:self action:@selector(handlePan:)];
            [self.presentedViewController hg_dismissViewControllerAnimated:YES completion:nil];
        }
        
    }
    
    if (_animateStyle == HGTransitionAnimatorFromBottomStyle) {// 从底部出来的样式
        if (vy > kVelocityY && v.y > 0) {
            [recognizer removeTarget:self action:@selector(handlePan:)];
            [self.presentedViewController hg_dismissViewControllerAnimated:YES completion:nil];
        }
        
    }
    
    self.currentTranslation = translation;
    self.currentVelocity = v;
}

- (void)animateWithDuration:(NSTimeInterval )duration animations:(void (^)())animations completionDismiss:(BOOL)flag
{
    [UIView animateWithDuration:duration animations:animations completion:^(BOOL finished) {
        if (flag)
            [self.presentedViewController hg_dismissViewControllerAnimated:NO completion:nil];
    }];
}

@end




