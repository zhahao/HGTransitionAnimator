//
//  HGPresentationController.m
//  自定义转场动画_OC
//
//  Created by 查昊 on 16/5/23.
//  Copyright © 2016年 haocha. All rights reserved.
//

#import "HGPresentationController.h"
@interface  HGPresentationController()

@end
@implementation HGPresentationController
- (UIView*)coverView
{
    if (!_coverView) {
        self.coverView = [[UIView alloc]init];
        self.coverView.frame=[UIScreen mainScreen].bounds;
        self.coverView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
        [self.coverView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(close)]];
    }
    return _coverView;
}
-(instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController
{
    return [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
}
/// 即将布局子视图
-(void)containerViewWillLayoutSubviews
{
    
    if (self.isFirstPresent) [self.containerView insertSubview:self.coverView atIndex:0];
    if (CGRectEqualToRect(_presentFrame, CGRectZero)) {
        self.presentedView.frame=CGRectMake(0, kScreenHeight*0.5, kScreenWidth, kScreenHeight*0.5);
        
    }else{
        self.presentedView.frame=_presentFrame;
            [UIView animateWithDuration:0.25 animations:^{
                self.coverView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
            }];
    }
    
}

- (void)close{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    
}
@end
