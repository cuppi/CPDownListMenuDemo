//
//  CPDownListMenuAppearance.h
//  CPDownListMenuDemo
//
//  Created by cuppi on 2016/8/22.
//  Copyright © 2016年 cuppi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPDownListMenuAppearance : NSObject
@property (copy, nonatomic) UIColor *segmentColor;
@property (assign, nonatomic) CGFloat menuHeight;
@property (assign, nonatomic) CGFloat downListHeight;
@property (retain, nonatomic) UIView *headerView;
@property (retain, nonatomic) UIView *footerView;
@property (retain, nonatomic) NSDictionary <NSString *, Class>*cellClassMap;
@property (retain, nonatomic) NSDictionary <NSString *, UINib *>*cellNibMap;
@end
