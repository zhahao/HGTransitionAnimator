//
//  UIView+HGExtension.m
//  HGTransitionAnimator
//
//  Created by 查昊 on 16/6/1.
//  Copyright © 2016年 haocha. All rights reserved.
//

#import "UIView+HGExtension.h"

@implementation UIView (HGExtension)

- (void)setHg_x:(CGFloat)hg_x
{
    CGRect frame = self.frame;
    frame.origin.x = hg_x;
    self.frame = frame;
}

- (void)setHg_y:(CGFloat)hg_y
{
    CGRect frame = self.frame;
    frame.origin.y = hg_y;
    self.frame = frame;
}

- (CGFloat)hg_x
{
    return self.frame.origin.x;
}

- (CGFloat)hg_y
{
    return self.frame.origin.y;
}

- (void)setHg_w:(CGFloat)hg_w
{
    CGRect frame = self.frame;
    frame.size.width = hg_w;
    self.frame = frame;
}

- (void)setHg_h:(CGFloat)hg_h
{
    CGRect frame = self.frame;
    frame.size.height = hg_h;
    self.frame = frame;
}

- (CGFloat)hg_h
{
    return self.frame.size.height;
}

- (CGFloat)hg_w
{
    return self.frame.size.width;
}
@end



