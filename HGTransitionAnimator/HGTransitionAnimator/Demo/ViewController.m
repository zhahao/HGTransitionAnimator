//
//  ViewController.m
//  HGTransitionAnimator
//
//  Created by 查昊 on 16/5/24.
//  Copyright © 2016年 haocha. All rights reserved.
//

#import "ViewController.h"
#import "OneViewController.h"
#import "UIViewController+HGAnimator.h"
#import "HGPresentationController.h"

#define kScreenWidth    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight   [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<HGTransitionAnimatorDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) CGRect presentFrame;
@property (nonatomic, strong) OneViewController*toCtrl;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) NSMutableArray *styles;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *animateSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *responseSegment;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@end
@implementation ViewController
- (NSMutableArray*)styles
{
    if (!_styles) {
        _styles = [[NSMutableArray alloc]initWithObjects:  @"自定义(上面的滑动条控制动画时间,最大5秒)",
                                                           @"从左边弹出样式",
                                                           @"从右边弹出样式",
                                                           @"从顶部弹出样式",
                                                           @"从底部弹出样式",
                                                           @"显示隐藏样式",
                                                           @"垂直压缩样式",
                                                           @"水平压缩样式",
                                                           @"中心点消失样式",
                                                           @"顶部中点消失样式",
                                                           @"顶部左上角消失样式",
                                                           @"顶部右上角消失样式",nil];
    }
    return _styles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect presentFrame=CGRectMake(kScreenWidth*0.1, kScreenHeight*0.2, kScreenWidth*0.8,  kScreenHeight*0.6);
    self.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.presentFrame=presentFrame;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.styles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleGray;
    cell.textLabel.text=self.styles[indexPath.row];
    cell.textLabel.textAlignment=NSTextAlignmentCenter;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    __weak typeof(self) ws=self;
    OneViewController *oneVC=[[OneViewController alloc]init];
    oneVC.callBackBlock=^(NSString *text){
        ws.messageLabel.text=text;
    };
     [self hg_presentViewController:oneVC animateStyle:(HGTransitionAnimatorStyle)indexPath.row  delegate:self presentFrame:_presentFrame backgroundColor:_backgroundColor animated:!self.animateSegment.selectedSegmentIndex];
}

#pragma mark - HGTransitionAnimatorDelegate
- (void)transitionAnimator:(HGTransitionAnimator *)animator animateTransitionToView:(UIView *)toView duration:(NSTimeInterval)duration{
    toView.transform=CGAffineTransformMakeScale(0.0, 1.0);
    [UIView animateWithDuration:duration animations:^{
        toView.transform=CGAffineTransformIdentity;
    }];
}

- (void)transitionAnimator:(HGTransitionAnimator *)animator animateTransitionFromView:(UIView *)fromView duration:(NSTimeInterval)duration{
    [UIView animateWithDuration:duration animations:^{
        fromView.transform=CGAffineTransformMakeScale(0.00001, 1.0);
    }];
}

- (void)transitionAnimator:(HGTransitionAnimator *)animator animationControllerForDismissedController:(UIViewController *)dismissed
{
    NSLog(@"presentedController=`%@`---dismissed",dismissed);
}

- (void)transitionAnimator:(HGTransitionAnimator *)animator animationControllerForPresentedController:(UIViewController *)presented
{
    NSLog(@"presentedController=`%@`---presented",presented);
}

- (NSTimeInterval)transitionDuration:(HGTransitionAnimator *)animator
{
    return self.slider.value;
}

- (BOOL)transitionAnimatorCanResponse:(HGTransitionAnimator *)animator
{
    return !self.responseSegment.selectedSegmentIndex;
}
@end