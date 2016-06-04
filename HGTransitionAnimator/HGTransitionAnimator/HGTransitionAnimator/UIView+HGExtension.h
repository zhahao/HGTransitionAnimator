//
//  UIView+HGExtension.h
//  HGTransitionAnimator
//
//  Created by 查昊 on 16/6/1.
//  Copyright © 2016年 haocha. All rights reserved.
//  github地址:https://github.com/zhahao/HGTransitionAnimator

#import <UIKit/UIKit.h>

@interface UIView (HGExtension)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@end

@interface UIColor (HGExtension)
@property (nonatomic, readonly) CGFloat red;
@property (nonatomic, readonly) CGFloat green;
@property (nonatomic, readonly) CGFloat blue;
@property (nonatomic, readonly) CGFloat alpha;
@end
