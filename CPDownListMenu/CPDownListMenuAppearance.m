//
//  CPDownListMenuAppearance.m
//  CPDownListMenuDemo
//
//  Created by cuppi on 2016/8/22.
//  Copyright © 2016年 cuppi. All rights reserved.
//

#import "CPDownListMenuAppearance.h"
#import "CPDownListMenuMacro.h"

@implementation CPDownListMenuAppearance
- (instancetype)init
{
    if (self = [super init]) {
        [self cp_createMetadata];
    }
    return self;
}

- (void)cp_createMetadata
{
    _menuHeight = 50;
    _downListHeight = 200;
    _segmentColor = [UIColor lightGrayColor];
}

- (void)setMenuHeight:(CGFloat)menuHeight
{
    _menuHeight = menuHeight;
    [self postNotificationWithUserInfo:@{@"menuHeight":@(menuHeight)}];
}

- (void)setDownListHeight:(CGFloat)downListHeight
{
    _downListHeight = downListHeight;
}

- (void)setCellNibMap:(NSDictionary<NSString *,UINib *> *)cellNibMap
{
    _cellNibMap = cellNibMap;
    [self postNotificationWithUserInfo:@{@"cellNibMap":@""}];
}

- (void)setCellClassMap:(NSDictionary<NSString *,Class> *)cellClassMap
{
    _cellClassMap = cellClassMap;
    [self postNotificationWithUserInfo:@{@"cellClassMap":@""}];
}

- (void)postNotificationWithUserInfo:(NSDictionary *)userInfo
{
    [[NSNotificationCenter defaultCenter]postNotificationName:__CPDownListMenuAppearance_kNotification object:nil userInfo:userInfo];
}

@end
