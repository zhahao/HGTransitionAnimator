//
//  TwoViewController.m
//  HGTransitionAnimator
//
//  Created by 查昊 on 16/5/24.
//  Copyright © 2016年 haocha. All rights reserved.
//

#import "OneViewController.h"
#import "UIViewController+HGAnimator.h"
#import "HGPresentationController.h"

@interface OneViewController ()<HGPresentationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *animateSegment;
@end

@implementation OneViewController
#pragma mark - 这个控制器随便写写
- (void)viewDidLoad {
    [super viewDidLoad];
    HGPresentationController *pc=[self hg_getPresentationController];
    pc.hg_delegate=self;
}
- (IBAction)backBtnClick:(id)sender {
    [self hg_dismissViewControllerAnimated:!self.animateSegment.selectedSegmentIndex completion:nil];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    __weak typeof (self)ws=self;
    if (_callBackBlock)  _callBackBlock(ws.textField.text);
}

-(BOOL)coverViewWillDismiss:(UIView *)coverView duration:(NSTimeInterval)duration
{
    NSLog(@"Do Something with%f s",duration);
    return !_animateSegment.selectedSegmentIndex;
}
//-(void)dealloc
//{
//    NSLog(@"%s",__func__);
//}
@end
