//
//  HGPresentationController.h
//  自定义转场动画_OC
//
//  Created by 查昊 on 16/5/23.
//  Copyright © 2016年 haocha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HGPresentationController : UIPresentationController
@property (nonatomic, assign) CGRect presentFrame;// <- 记录当前的frame
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, assign,getter=isFirstPresent) BOOL firstPresent;
@property (nonatomic, strong) UIColor *backgroundColor;

@property (nonatomic, assign) NSTimeInterval duration;//<- 动画时间 deflaut=0.25s
@property (nonatomic, assign) NSTimeInterval pushDuration;//<- push动画时间 deflaut=0.25s
@property (nonatomic, assign) NSTimeInterval popDuration;//<- pop动画时间 deflaut=0.25s

@end
