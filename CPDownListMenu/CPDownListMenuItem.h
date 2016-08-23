//
//  CPDownListMenuItem.h
//  CPDownListMenuDemo
//
//  Created by cuppi on 2016/8/22.
//  Copyright © 2016年 cuppi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPDownListMenuItem : UIView
@property (copy, nonatomic) void(^clickBlock)();
@property (retain, nonatomic) UIButton *titleButton;
- (void)fillDataWithTitle:(NSString *)title;
@end
