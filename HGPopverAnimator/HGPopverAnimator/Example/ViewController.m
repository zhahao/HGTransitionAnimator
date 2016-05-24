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
@interface ViewController ()
@property (nonatomic, strong) HGPopverAnimator*popverAnimator;
@end

@implementation ViewController
- (HGPopverAnimator*)popverAnimator
{
    if (!_popverAnimator) {
        self.popverAnimator = [[HGPopverAnimator alloc]init];
        self.popverAnimator.presentFrame=CGRectMake(0, kScreenHeight*0.5, kScreenWidth, kScreenHeight*0.5);
        self.popverAnimator.animateStyle=HGPopverAnimatorFromRightStyle;
    }
    return _popverAnimator;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    OneViewController *toCtrl=[[OneViewController alloc]init];
    toCtrl.modalPresentationStyle=UIModalPresentationCustom;
    toCtrl.transitioningDelegate=self.popverAnimator;
    [self presentViewController:toCtrl animated:YES completion:nil];
}
@end