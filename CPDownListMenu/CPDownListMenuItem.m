//
//  CPDownListMenuItem.m
//  CPDownListMenuDemo
//
//  Created by cuppi on 2016/8/22.
//  Copyright © 2016年 cuppi. All rights reserved.
//

#import "CPDownListMenuItem.h"
#import "UIView+CPGrid.h"

@implementation CPDownListMenuItem

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self cp_configureCell];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (void)cp_configureCell
{
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cp_actionClickGesture)]];
}

- (void)fillDataWithTitle:(NSString *)title
{
    [_titleButton setTitle:title forState:UIControlStateNormal];
}

#pragma mark -- override method
- (void)layoutSubviews
{
    _titleButton.frame = self.bounds;
}

- (void)setTitleButton:(UIButton *)titleButton
{
    [_titleButton removeFromSuperview];
    _titleButton = titleButton;
    [self addSubview:_titleButton];
    _titleButton.frame = self.bounds;
    _titleButton.userInteractionEnabled = NO;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

#pragma mark -- action area
- (void)cp_actionClickGesture
{
    self.clickBlock();
}

@end
