//
//  CPDownListMenu.m
//  CPDownListMenuDemo
//
//  Created by cuppi on 2016/8/16.
//  Copyright © 2016年 cuppi. All rights reserved.
//

#import "CPDownListMenu.h"
#import "UIView+CPGrid.h"
#import "CPDownListMenuMacro.h"


@interface CPDownListMenu() <UITableViewDelegate, UITableViewDataSource>
{
    CPDownListMenuAppearance *_appearance;
    NSMutableArray <CPDownListMenuItem *>*_menuItems;
    UIView *_headerView;
    UIView *_dataView;
    UIView *_footerView;
    BOOL _isShowDownList;
}
@end

@implementation CPDownListMenu

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _appearance = [[CPDownListMenuAppearance alloc] init];
        [self createMetadata];
        [self createAppearanceListener];
        [self createTableView];
        [self reloadData];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame downListMenuAppearance:nil];
}

- (instancetype)initWithFrame:(CGRect)frame
       downListMenuAppearance:(CPDownListMenuAppearance *)downListMenuAppearance
{
    if (self = [super initWithFrame:frame]) {
        if (downListMenuAppearance) {
            _appearance = downListMenuAppearance;
        }
        else
        {
            _appearance = [[CPDownListMenuAppearance alloc] init];
        }
        [self createMetadata];
        [self createAppearanceListener];
        [self createTableView];
        [self reloadData];
    }
    return self;
}

- (void)createMetadata
{
    _menuItems = [NSMutableArray arrayWithCapacity:10];
    _showMenuIndex = CPDownListMenuUnShow;
    _absoluteFrame = CGRectNull;
}

- (void)createAppearanceListener
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionUpdateAppearance:) name:__CPDownListMenuAppearance_kNotification object:nil];
}

- (void)createTableView
{
    _dataView = [[UIView alloc] initWithFrame:CGRectMake(0, _appearance.menuHeight, [UIScreen mainScreen].bounds.size.width, 0)];
    [self addSubview:_dataView];
    _dataView.clipsToBounds = YES;
    
    _dataTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0) style:UITableViewStylePlain];
    [_dataView addSubview:_dataTableView];
    _dataTableView.delegate = self;
    _dataTableView.dataSource = self;
    
    [_appearance.cellNibMap enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull identifier, UINib * _Nonnull cellNib, BOOL * _Nonnull stop) {
        [_dataTableView registerNib:cellNib forCellReuseIdentifier:identifier];
    }];
    [_appearance.cellClassMap enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull identifier, Class  _Nonnull cellClass, BOOL * _Nonnull stop) {
        [_dataTableView registerClass:cellClass  forCellReuseIdentifier:identifier];
    }];
}

- (void)setStickView:(UIView *)stickView
{
    _stickView = stickView;
    if (CGRectEqualToRect(_absoluteFrame, CGRectNull)) {
        _dataView.frame = [self convertRect:_dataView.frame toView:_stickView];
    }
    else
    {
        _dataView.frame = _absoluteFrame;
    }
    [_stickView addSubview:_dataView];
}

- (void)setAbsoluteFrame:(CGRect)absoluteFrame
{
    _absoluteFrame = CGRectMake(absoluteFrame.origin.x, absoluteFrame.origin.y, absoluteFrame.size.width, 0);
    _dataView.frame = _absoluteFrame;
}

- (void)setMenuTitle:(NSString *)title
             atIndex:(NSInteger)index
{
    if (index < 0 ||
        index >= _menuItems.count) {
        NSLog(@"菜单index不合法");
        return;
    }
    CPDownListMenuItem *item = _menuItems[index];
    [item fillDataWithTitle:title];
}

- (void)reloadData
{
    if (!self.datasource) {
        return;
    }
    [_menuItems enumerateObjectsUsingBlock:^(CPDownListMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [_menuItems removeAllObjects];
    
    NSInteger count = 1;
    if ([self.datasource respondsToSelector:@selector(numberOfMenuCellsInDownListMenu:)]) {
        count = [self.datasource numberOfMenuCellsInDownListMenu:self];
    }
    
    CGFloat width = self.cp_width/count;
    CGFloat height = _appearance.menuHeight;
    for (NSInteger i = 0; i < count; i++) {
        CPDownListMenuItem *item = [[CPDownListMenuItem alloc] init];
        if ([self.datasource respondsToSelector:@selector(downListMenu:menuAtIndex:)]) {
            item = [self.datasource downListMenu:self menuAtIndex:i];
        }
        [self insertSubview:item atIndex:0];
        [_menuItems addObject:item];
        item.frame = CGRectMake(i*width, 0, width, height);
        __weak typeof(self) selfWeak = self;
        __weak typeof(item) itemWeak = item;
        [item setClickBlock:^{
#warning "The word - did is mismatch"
            if (_autoFoldDownList) {
                if (_showMenuIndex != i) {
                    [selfWeak showMenuAtIndex:i];
                }
                else
                {
                    [selfWeak hideMenu];
                }
            }
            
            if ([self.delegate respondsToSelector:@selector(downListMenu:didSelectMenuAtIndex:menuItem:)]) {
                [self.delegate downListMenu:self didSelectMenuAtIndex:i menuItem:itemWeak];
            }
        }];
        if (i) {
            CALayer *layer = [[CALayer alloc] init];
            [self.layer addSublayer:layer];
            layer.backgroundColor = _appearance.segmentColor.CGColor;
            layer.bounds = CGRectMake(0, 0, 1, height - 8*2);
            layer.position = CGPointMake(i*width, height/2);
            layer.cornerRadius = 1;
        }
    }
    [_dataTableView reloadData];
}

#pragma mark -- 接口函数
- (BOOL)showDownList
{
    return _showMenuIndex != CPDownListMenuUnShow;
}

- (NSArray <CPDownListMenuItem *>*)allMenuItems
{
    return _menuItems;
}

- (__kindof UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    UITableViewCell *cell = [_dataTableView dequeueReusableCellWithIdentifier:identifier];
    NSAssert(cell, @"获取没有注册的Cell: %@", identifier);
    return cell;
}

- (void)showMenuAtIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(downListMenu:willShowDownListAtIndex:)]) {
        [self.delegate downListMenu:self willShowDownListAtIndex:index];
    }
    _showMenuIndex = index;
    [_footerView removeFromSuperview];
    [_headerView removeFromSuperview];
    
    if (_appearance.headerView) {
        _headerView =  _appearance.headerView;
    }
    if ([self.delegate respondsToSelector:@selector(downListMenu:viewForHeaderAtMenuIndex:)]) {
        _headerView = [self.datasource downListMenu:self viewForHeaderAtMenuIndex:index];
    }
    if (_headerView) {
        [_dataView addSubview:_headerView];
    }
    
    if (_appearance.footerView) {
        _footerView =  _appearance.footerView;
    }
    if ([self.delegate respondsToSelector:@selector(downListMenu:viewForFooterAtMenuIndex:)]) {
        _footerView = [self.datasource downListMenu:self viewForFooterAtMenuIndex:index];
    }
    if (_footerView) {
        [_dataView addSubview:_footerView];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        _dataView.cp_height = _appearance.downListHeight;
        _headerView.cp_top = 0;
        _dataTableView.cp_top = _headerView.cp_height;
        _dataTableView.cp_height = _appearance.downListHeight - _footerView.cp_height - _headerView.cp_height;
        _footerView.cp_top = _dataTableView.cp_bottom;
    }];
    _dataTableView.contentOffset = CGPointZero;
    [_dataTableView reloadData];
}

- (void)hideMenuWithCompletion:(void (^)(BOOL finished))completion
{
    if ([self.delegate respondsToSelector:@selector(downListMenu:willHideDownListAtIndex:)]) {
        [self.delegate downListMenu:self willHideDownListAtIndex:_showMenuIndex];
    }
    _showMenuIndex = CPDownListMenuUnShow;
    [UIView animateWithDuration:0.3 animations:^{
        _dataView.cp_height = 0;
        _dataTableView.cp_top = 0;
        _dataTableView.cp_height = 0;
        _footerView.cp_top = 0;
    } completion:completion];
}

- (void)hideMenu
{
    [self hideMenuWithCompletion:nil];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

#pragma mark -- action area
- (void)actionUpdateAppearance:(NSNotification *)notification
{
    if ([notification.userInfo objectForKey:@"menuHeight"]) {
        _dataView.cp_top = [[notification.userInfo objectForKey:@"menuHeight"] floatValue];
    }
    
    if ([notification.userInfo objectForKey:@"cellClassMap"]) {
        [_appearance.cellClassMap enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull identifier, Class  _Nonnull cellClass, BOOL * _Nonnull stop) {
            [_dataTableView registerClass:cellClass  forCellReuseIdentifier:identifier];
        }];
    }
    
    if ([notification.userInfo objectForKey:@"cellNibMap"]) {
        [_appearance.cellNibMap enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull identifier, UINib * _Nonnull cellNib, BOOL * _Nonnull stop) {
            [_dataTableView registerNib:cellNib forCellReuseIdentifier:identifier];
        }];
    }
}

#pragma mark -- tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.datasource downListMenu:self numberOfCellsAtMenuIndex:_showMenuIndex];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.datasource downListMenu:self cellAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:_showMenuIndex]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(downListMenu:didSelectCellAtIndexPath:)]) {
        [self.delegate downListMenu:self didSelectCellAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:_showMenuIndex]];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.datasource respondsToSelector:@selector(downListMenu:heightForCellAtIndexPath:)]) {
        return [self.datasource downListMenu:self heightForCellAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:_showMenuIndex]];
    }
    return 44;
}
@end
