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

@property (nonatomic, assign) CGRect leftPresentFrame;
@property (nonatomic, assign) CGRect rightPresentFrame;
@property (nonatomic, assign) CGRect topPresentFrame;
@property (nonatomic, assign) CGRect bottomPresentFrame;

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
    [self setupViews];
}

- (void)setupViews
{
    _leftPresentFrame = CGRectMake(0, 0, kScreenWidth * 0.7,  kScreenHeight);
    _rightPresentFrame = CGRectMake(kScreenWidth * 0.3, 0, kScreenWidth * 0.7,  kScreenHeight);
    _topPresentFrame = CGRectMake(0, 0, kScreenWidth,  kScreenHeight * 0.3);
    _bottomPresentFrame = CGRectMake(kScreenWidth * 0.1, kScreenHeight * 0.35, kScreenWidth * 0.8,  kScreenHeight * 0.3);
    _backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
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
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.text = self.styles[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    OneViewController *oneVC = [OneViewController new];
    // 有循环引用
    __weak typeof(self) weak_self = self;
    __weak typeof(self) weak_oneVC = self;
    oneVC.dismiss = ^ (NSString *text){
        __strong typeof(weak_self) self = weak_self;
        __strong typeof(weak_oneVC) oneVC = weak_oneVC;
        if (!self) return;
        self.messageLabel.text = text;
        if (!oneVC) return;
        [oneVC hg_dismissViewControllerAnimated:YES completion:NULL];
    };

    CGRect  frame = CGRectZero;
    switch (indexPath.row) {
        case 1: frame = _leftPresentFrame; break;
        case 2: frame = _rightPresentFrame; break;
        case 3: frame = _topPresentFrame; break;
        case 4: frame = _bottomPresentFrame; break;
        default:{ frame = CGRectMake(kScreenWidth * 0.15, kScreenHeight * 0.25, kScreenWidth * 0.7, kScreenHeight * 0.5); }break;
    }

    // 弹出控制器
    [self hg_presentViewController:oneVC
                      animateStyle:(HGTransitionAnimatorStyle)indexPath.row
                          delegate:self
                      presentFrame:frame
                   backgroundColor:_backgroundColor
                          animated:!self.animateSegment.selectedSegmentIndex];
}

#pragma mark - HGTransitionAnimatorDelegate
- (void)transitionAnimator:(HGTransitionAnimator *)animator
   animateTransitionToView:(UIView *)toView
                  duration:(NSTimeInterval)duration{
    
    toView.transform = CGAffineTransformMakeScale(0.0, 1.0);
    [UIView animateWithDuration:duration animations:^{
        toView.transform = CGAffineTransformIdentity;
    }];
}

- (void)transitionAnimator:(HGTransitionAnimator *)animator
 animateTransitionFromView:(UIView *)fromView
                  duration:(NSTimeInterval)duration{

    [UIView animateWithDuration:duration animations:^{
        fromView.transform = CGAffineTransformMakeScale(0.00001, 1.0);
    }];
}

- (void)transitionAnimator:(HGTransitionAnimator *)animator animationControllerForDismissedController:(UIViewController *)dismissed
{
    // 被弹出的控制器已经消失
}

- (void)transitionAnimator:(HGTransitionAnimator *)animator animationControllerForPresentedController:(UIViewController *)presented
{
    // 被弹出的控制器已经弹出
}

// 如果在构造函数里面animated=NO, 就不要实现返回时间的代理
//- (NSTimeInterval)transitionDuration:(HGTransitionAnimator *)animator
//{
//    return self.slider.value;
//}

- (BOOL)transitionAnimatorCanResponse:(HGTransitionAnimator *)animator
{
    return !self.responseSegment.selectedSegmentIndex;
}
@end
