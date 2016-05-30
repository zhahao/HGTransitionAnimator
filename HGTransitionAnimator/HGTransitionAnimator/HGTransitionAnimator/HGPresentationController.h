//
//  HGPresentationController.h
//  HGTransitionAnimator
//
//  Created by 查昊 on 16/5/23.
//  Copyright © 2016年 haocha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGTransitionAnimatorDelegate.h"
#import "HGTransitionAnimator.h"

@interface HGPresentationController : UIPresentationController
@property (nonatomic, assign) CGRect presentFrame;// <- 记录当前的frame
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, assign,getter=canResponse) BOOL response;
@property (nonatomic, assign)id <HGPresentationControllerDelegate> hg_delegate;
@property (nonatomic, assign)NSTimeInterval duration;
@property (nonatomic, assign)HGTransitionAnimatorStyle animateStyle;
@property (nonatomic, assign,getter=canPanLeftOrRight) BOOL panLeftOrRight;
@property (nonatomic, assign,getter=canPanTopOrBottom) BOOL panTopOrBottom;
@end
