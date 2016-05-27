//
//  ViewController.m
//  HGPopverAnimator
//
//  Created by 查昊 on 16/5/24.
//  Copyright © 2016年 haocha. All rights reserved.
//

#import "ViewController.h"
#import "OneViewController.h"
#import "UIViewController+HGPopver.h"
#import "HGPresentationController.h"

#define kScreenBounds [UIScreen mainScreen].bounds
#define kScreenWidth   kScreenBounds.size.width
#define kScreenHeight   kScreenBounds.size.height
#define OneViewControllerINIT   [[OneViewController alloc]init]
@interface ViewController ()<HGPopverAnimatorDelegate>
@property (nonatomic, strong) OneViewController*toCtrl;
@property (nonatomic, assign) CGRect presentFrame;
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect presentFrame=CGRectMake(kScreenWidth*0.2, kScreenHeight*0.2, kScreenWidth*0.6,  kScreenHeight*0.6);
    self.presentFrame=presentFrame;
}
- (IBAction)fromLeftStyle{
    [self hg_presentViewController:OneViewControllerINIT animateStyle:HGPopverAnimatorFromLeftStyle delegate:nil presentFrame:_presentFrame  animated:YES];
}
- (IBAction)horizontalScaleStyle{
    [self hg_presentViewController:OneViewControllerINIT animateStyle:HGPopverAnimatorHorizontalScaleStyle delegate:nil presentFrame:_presentFrame  animated:YES];
}
- (IBAction)verticalScaleStyle{
    [self hg_presentViewController:OneViewControllerINIT animateStyle:HGPopverAnimatorVerticalScaleStyle delegate:nil presentFrame:_presentFrame animated:NO];
}
- (IBAction)FromTopStyle{
    [self hg_presentViewController:OneViewControllerINIT animateStyle:HGPopverAnimatorFromTopStyle delegate:nil presentFrame:_presentFrame animated:YES];
}
- (IBAction)fromBottomStyle{
    [self hg_presentViewController:OneViewControllerINIT animateStyle:HGPopverAnimatorFromBottomStyle delegate:nil presentFrame:_presentFrame animated:NO];
}
- (IBAction)fromRightStyle{
    [self hg_presentViewController:OneViewControllerINIT animateStyle:HGPopverAnimatorFromRightStyle delegate:nil presentFrame:_presentFrame animated:NO];
}
- (IBAction)customStyle{
    [self hg_presentViewController:OneViewControllerINIT animateStyle:HGPopverAnimatorCustomStyle delegate:self presentFrame:_presentFrame animated:YES];
}
#pragma mark -HGPopverAnimatorDelegate
-(void)popverAnimateTransitionToView:(UIView *)toView duration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration animations:^{
        toView.layer.transform=CATransform3DMakeRotation(M_PI, 0, 1, 0);
    }];
    
}
-(void)popverAnimateTransitionFromView:(UIView *)fromView duration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration animations:^{
        fromView.layer.transform=CATransform3DIdentity;
    }];
}
- (NSTimeInterval)popverTransitionDuration
{
    return 3;
}
@end