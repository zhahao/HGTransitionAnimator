//
//  TwoViewController.m
//  HGPopverAnimator
//
//  Created by 查昊 on 16/5/24.
//  Copyright © 2016年 haocha. All rights reserved.
//

#import "OneViewController.h"
#import "UIViewController+HGAnimator.h"
@interface OneViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *animateSegment;
@end

@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
-(void)dealloc
{
    NSLog(@"%s",__func__);
}
@end
