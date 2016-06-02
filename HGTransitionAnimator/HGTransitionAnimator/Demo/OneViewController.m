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
static NSString * ID=@"cell";

@interface OneViewController ()<HGPresentationControllerDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation OneViewController
#pragma mark - 这个控制器随便写写
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
    UIView *emtyV=[[UIView alloc]initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:emtyV];
    HGPresentationController *pc=[self hg_getPresentationController];
    // 激活拖拽消失手势
    pc.activeDrag=YES;
    pc.hg_delegate=self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(BOOL)presentedViewBeginDismiss:(NSTimeInterval)duration
{
    return YES;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text=[NSString stringWithFormat:@"第 %d 行数据",(int)indexPath.row+1];
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.backgroundColor=[UIColor blackColor];
    cell.contentView.backgroundColor=[UIColor blackColor];
    cell.textLabel.textAlignment=NSTextAlignmentCenter;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *text=[[[tableView cellForRowAtIndexPath:indexPath] textLabel] text];
    self.callBackBlock(text);
    [self hg_dismissViewControllerAnimated:YES completion:nil];
}


@end
