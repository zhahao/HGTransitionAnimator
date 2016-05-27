//
//  HGPresentationController.m
//  自定义转场动画_OC
//
//  Created by 查昊 on 16/5/23.
//  Copyright © 2016年 haocha. All rights reserved.
//

#import "HGPresentationController.h"
@interface  HGPresentationController()
@property (nonatomic, assign) CGRect showFrame;
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
        self.coverView.frame=[UIScreen mainScreen].bounds;
        self.coverView.backgroundColor=[UIColor clearColor];
        [self.coverView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(close)]];
    }
    return _coverView;
}

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController
{
    return [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
}
/// 即将布局子视图
- (void)containerViewWillLayoutSubviews
{
    [self.containerView insertSubview:self.coverView atIndex:0];
    if (CGRectEqualToRect(_presentFrame, CGRectZero)) {
        self.presentedView.frame=self.showFrame;
    }else{
        self.presentedView.frame=_presentFrame;
    }
    
}

- (void)close{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}
@end
