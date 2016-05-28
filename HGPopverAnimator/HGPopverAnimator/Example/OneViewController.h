//
//  TwoViewController.h
//  HGPopverAnimator
//
//  Created by 查昊 on 16/5/24.
//  Copyright © 2016年 haocha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OneViewController : UIViewController
/// 数据回调,也可以用通知
@property (nonatomic, copy) void (^callBackBlock)(NSString *text);
@end
