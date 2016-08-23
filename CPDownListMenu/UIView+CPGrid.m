//
//  UIView+CPGrid.m
//  CPImageDisplayControllerDemo
//
//  Created by cuppi on 2016/8/10.
//  Copyright © 2016年 cuppi. All rights reserved.
//

#import "UIView+CPGrid.h"

@implementation UIView (CPGrid)

- (CGFloat)cp_centerX
{
    return self.center.x;
}

- (void)setCp_centerX:(CGFloat)cp_centerX
{
    self.center = CGPointMake(cp_centerX, self.center.y);
}

- (CGFloat)cp_centerY
{
    return self.center.y;
}

- (void)setCp_centerY:(CGFloat)cp_centerY
{
    self.center = CGPointMake(self.center.x, cp_centerY);
}

- (CGFloat)cp_left
{
    return self.frame.origin.x;
}

- (void)setCp_left:(CGFloat)cp_left
{
    CGRect frame = self.frame;
    frame.origin = CGPointMake(cp_left, frame.origin.y);
    self.frame = frame;
}

- (CGFloat)cp_right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setCp_right:(CGFloat)cp_right
{
    CGRect frame = self.frame;
    frame.origin = CGPointMake(cp_right - frame.size.width, frame.origin.y);
    self.frame = frame;
}

- (CGFloat)cp_top
{
    return self.frame.origin.y;
}

- (void)setCp_top:(CGFloat)cp_top
{
    CGRect frame = self.frame;
    frame.origin = CGPointMake(frame.origin.x, cp_top);
    self.frame = frame;
}

- (CGFloat)cp_bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setCp_bottom:(CGFloat)cp_bottom
{
    CGRect frame = self.frame;
    frame.origin = CGPointMake(frame.origin.x, cp_bottom - frame.size.height);
    self.frame = frame;
}

- (CGFloat)cp_width
{
    return self.frame.size.width;
}

- (void)setCp_width:(CGFloat)cp_width
{
    CGRect frame = self.frame;
    frame.size = CGSizeMake(cp_width, frame.size.height);
    self.frame = frame;
}

- (CGFloat)cp_height
{
    return self.frame.size.height;
}

- (void)setCp_height:(CGFloat)cp_height
{
    CGRect frame = self.frame;
    frame.size = CGSizeMake(frame.size.width, cp_height);
    self.frame = frame;
}

@end
