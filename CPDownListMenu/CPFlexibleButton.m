//
//  CPFlexibleButton.m
//  IYIFen
//
//  Created by cuppi on 2016/8/16.
//  Copyright © 2016年 cuppi. All rights reserved.
//

#import "CPFlexibleButton.h"
#import "UIView+CPGrid.h"

@implementation CPFlexibleButton
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createMetadata];
        [self configureButton];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self configureButton];
    }
    return self;
}

- (void)createMetadata
{
    _edgeSpace = 8;
    _betweenSpace = 2;
    _cp_horizontalAlignment = UIControlContentHorizontalAlignmentCenter;
}

- (void)configureButton
{
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
}

- (void)setEdgeSpace:(CGFloat)edgeSpace
{
    _edgeSpace = edgeSpace;
    [self setNeedsDisplay];
}

- (void)setBetweenSpace:(CGFloat)betweenSpace
{
    _betweenSpace = betweenSpace;
    [self setNeedsDisplay];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat betweenSpace = _betweenSpace;
    CGSize imageSize = self.currentImage.size;
    // |-(_edgeSpace)- title -(_halfBetweenSpace*2)- image -(_edgeSpace)-|
    // 保持图片大小不变 文本的最大长度
    CGFloat titleMaxWidth = MAX(0, self.cp_width - imageSize.width - _edgeSpace*2 - betweenSpace);
    // 获取 文本能显示的大小
    CGSize titleSize = CGSizeMake(MIN(self.titleLabel.intrinsicContentSize.width, titleMaxWidth), self.cp_height);
    CGFloat buttonWidth = self.cp_width;
    
    CGFloat maxSpace = MAX(betweenSpace, (buttonWidth - (imageSize.width + titleSize.width) - _edgeSpace*2));
    
    // 上左下右
    if (_cp_horizontalAlignment == UIControlContentHorizontalAlignmentCenter) {
        self.titleEdgeInsets = UIEdgeInsetsMake(0, _edgeSpace + (-imageSize.width), 0, _edgeSpace + betweenSpace + imageSize.width);
        self.imageEdgeInsets = UIEdgeInsetsMake(0, _edgeSpace + titleSize.width + betweenSpace, 0, _edgeSpace + -titleSize.width);
    }
    if (_cp_horizontalAlignment == UIControlContentHorizontalAlignmentLeft) {
        self.titleEdgeInsets = UIEdgeInsetsMake(0, _edgeSpace + (-imageSize.width), 0, _edgeSpace + maxSpace + imageSize.width);
        self.imageEdgeInsets = UIEdgeInsetsMake(0, _edgeSpace + titleSize.width + betweenSpace, 0, _edgeSpace + -titleSize.width + maxSpace);
    }
    if (_cp_horizontalAlignment == UIControlContentHorizontalAlignmentRight) {
        self.titleEdgeInsets = UIEdgeInsetsMake(0, _edgeSpace + (-imageSize.width) + (maxSpace - betweenSpace), 0, _edgeSpace + betweenSpace + imageSize.width);
        self.imageEdgeInsets = UIEdgeInsetsMake(0, _edgeSpace + titleSize.width + maxSpace, 0, _edgeSpace + -titleSize.width);
    }
    if (_cp_horizontalAlignment == UIControlContentHorizontalAlignmentFill) {
        self.titleEdgeInsets = UIEdgeInsetsMake(0, _edgeSpace + (-imageSize.width), 0, _edgeSpace + maxSpace + imageSize.width);
        self.imageEdgeInsets = UIEdgeInsetsMake(0, _edgeSpace + titleSize.width + maxSpace, 0, _edgeSpace + -titleSize.width);
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
