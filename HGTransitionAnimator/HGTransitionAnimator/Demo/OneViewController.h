//
//  TwoViewController.h
//  HGTransitionAnimator
//
//  Created by 查昊 on 16/5/24.
//  Copyright © 2016年 haocha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OneViewController : UIViewController
/// 数据回调Block,也可以用通知或代理
@property (nonatomic, copy) void (^callBackBlock)(NSString *text);
@end
