//
//  ViewController.m
//  HGPopverAnimator
//
//  Created by 查昊 on 16/5/24.
//  Copyright © 2016年 haocha. All rights reserved.
//

#import "ViewController.h"
#import "OneViewController.h"
#import "HGPopverAnimator.h"
#import "HGPresentationController.h"
#import "UIViewController+HGPopver.h"
@interface ViewController ()<HGPopverAnimatorDelegate>
@property (nonatomic, strong) OneViewController*toCtrl;
@property (nonatomic, assign) CGRect presentFrame;
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    OneViewController *toCtrl=[[OneViewController alloc]init];
    self.toCtrl=toCtrl;
    
    CGRect presentFrame=CGRectMake(100, 100, 100, 100);
    self.presentFrame=presentFrame;
}
- (IBAction)fromLeftStyle{
    [self presentViewController:self.toCtrl animateStyle:HGPopverAnimatorFromLeftStyle delegate:nil presentFrame:_presentFrame relateView:nil animated:YES];
}
- (IBAction)horizontalScaleStyle{
    [self presentViewController:self.toCtrl animateStyle:HGPopverAnimatorFromLeftStyle delegate:nil presentFrame:_presentFrame relateView:nil animated:YES];
}
- (IBAction)verticalScaleStyle{
    [self presentViewController:self.toCtrl animateStyle:HGPopverAnimatorFromLeftStyle delegate:nil presentFrame:_presentFrame relateView:nil animated:YES];
}
- (IBAction)FromTopStyle{
    [self presentViewController:self.toCtrl animateStyle:HGPopverAnimatorFromLeftStyle delegate:nil presentFrame:_presentFrame relateView:nil animated:YES];
}
- (IBAction)fromBottomStyle{
    [self presentViewController:self.toCtrl animateStyle:HGPopverAnimatorFromLeftStyle delegate:nil presentFrame:_presentFrame relateView:nil animated:YES];
}
- (IBAction)fromRightStyle{
    [self presentViewController:self.toCtrl animateStyle:HGPopverAnimatorFromLeftStyle delegate:nil presentFrame:_presentFrame relateView:nil animated:YES];
}
- (IBAction)customStyle{
    [self presentViewController:self.toCtrl animateStyle:HGPopverAnimatorCustomStyle delegate:nil presentFrame:_presentFrame relateView:nil animated:YES];
}
#pragma mark -HGPopverAnimatorDelegate
-(void)popverAnimateTransitionToView:(UIView *)toView duration:(NSTimeInterval)duration
{
    NSLog(@"%f",duration);
}
-(void)popverAnimateTransitionFromView:(UIView *)fromView duration:(NSTimeInterval)duration
{
    NSLog(@"%f",duration);
}
@end