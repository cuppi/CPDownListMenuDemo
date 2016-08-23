//
//  CPDownListMenu.h
//  CPDownListMenuDemo
//
//  Created by cuppi on 2016/8/16.
//  Copyright © 2016年 cuppi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPDownListMenuAppearance.h"
#import "CPDownListMenuItem.h"

static NSInteger const CPDownListMenuUnShow = -1;

@class CPDownListMenu;
@protocol CPDownListMenuDelegate <NSObject>
@optional
- (void)downListMenu:(CPDownListMenu *)downListMenu didSelectMenuAtIndex:(NSInteger)index;
- (void)downListMenu:(CPDownListMenu *)downListMenu didSelectCellAtIndexPath:(NSIndexPath *)indexPath;
@end

@protocol CPDownListMenuDatasource <NSObject>
- (NSInteger)downListMenu:(CPDownListMenu *)downListMenu numberOfCellsAtMenuIndex:(NSInteger)index;
- (UITableViewCell *)downListMenu:(CPDownListMenu *)downListMenu cellAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (NSInteger)numberOfMenuCellsInDownListMenu:(CPDownListMenu *)downListMenu;
- (UIView *)downListMenu:(CPDownListMenu *)downListMenu viewForFooterAtMenuIndex:(NSInteger)index;
- (UIView *)downListMenu:(CPDownListMenu *)downListMenu viewForHeaderAtMenuIndex:(NSInteger)index;
- (CPDownListMenuItem *)downListMenu:(CPDownListMenu *)downListMenu menuAtIndex:(NSInteger)index;
- (CGFloat)downListMenu:(CPDownListMenu *)downListMenu heightForCellAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface CPDownListMenu : UIView
@property (assign, nonatomic) NSInteger showMenuIndex;
- (instancetype)initWithFrame:(CGRect)frame
       downListMenuAppearance:(CPDownListMenuAppearance *)downListMenuAppearance;
@property (assign, nonatomic) id<CPDownListMenuDelegate> delegate;
@property (assign, nonatomic) id<CPDownListMenuDatasource> datasource;
@property (retain, nonatomic) UIView *stickView;
@property (readonly, nonatomic) CPDownListMenuAppearance *appearance;
@property (assign, nonatomic) BOOL autoFoldDownList;
// 获取下拉列表的tableView importment: 该属性只限于设置tableView的UI属性 不要通过这个属性改变tableview的代理HeaderView
@property (retain, nonatomic) UITableView *dataTableView;

- (__kindof UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;
- (void)setMenuTitle:(NSString *)title
             atIndex:(NSInteger)index;
- (void)showMenuAtIndex:(NSInteger)index;
- (void)hideMenu;
- (void)reloadData;
@end
