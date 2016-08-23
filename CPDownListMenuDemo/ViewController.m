//
//  ViewController.m
//  CPDownListMenuDemo
//
//  Created by cuppi on 2016/8/16.
//  Copyright © 2016年 cuppi. All rights reserved.
//

#import "ViewController.h"
#import "CPDownListMenu.h"
#import "CPDownListMenuAppearance.h"
#import "UIView+CPGrid.h"

@interface ViewController () <CPDownListMenuDelegate, CPDownListMenuDatasource>
{
    NSArray <NSString *>*_data1List;
   NSArray <NSString *>*_data2List;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self createMetadata];
    [self createMenuView];
}

- (void)createMetadata
{
    _data1List = @[@"雪糕", @"年糕", @"发糕", @"蛋糕"];
    _data2List = @[@"北京", @"上海", @"武汉", @"成都", @"沈阳", @"辽宁"];
}

- (void)createMenuView
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
    footerView.backgroundColor = [UIColor colorWithRed:230/255.f green:230/255.f blue:230/255.f alpha:1];
    UIImageView *imageView = [[UIImageView alloc] init];
    [footerView addSubview:imageView];
    imageView.bounds = CGRectMake(0, 0, 25, 25);
    imageView.center = CGPointMake(footerView.cp_centerX, footerView.cp_centerY);
    imageView.image = [UIImage imageNamed:@"底部"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    CPDownListMenuAppearance *appearance = [[CPDownListMenuAppearance alloc] init];
    appearance.footerView = footerView;
    appearance.cellClassMap = @{@"UITableViewCell": UITableViewCell.class};
    
    CPDownListMenu *menu = [[CPDownListMenu alloc] initWithFrame:CGRectMake(0, 100, 320, 50) downListMenuAppearance:appearance];
    [self.view addSubview:menu];
    menu.stickView = self.view;
    menu.delegate = self;
    menu.datasource = self;
    [menu reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- CPDownListMenuDelegate & Datesource
- (void)downListMenu:(CPDownListMenu *)downListMenu didSelectMenuAtIndex:(NSInteger)index
{
    if (downListMenu.showMenuIndex != index) {
        [downListMenu showMenuAtIndex:index];
    }
    else
    {
        [downListMenu hideMenu];
    }
}

- (void)downListMenu:(CPDownListMenu *)downListMenu didSelectCellAtIndexPath:(NSIndexPath *)indexPath
{
    [downListMenu setMenuTitle:_data1List[indexPath.row] atIndex:indexPath.section];
}

- (CPDownListMenuItem *)downListMenu:(CPDownListMenu *)downListMenu menuAtIndex:(NSInteger)index
{
    CPDownListMenuItem *cell = [[CPDownListMenuItem alloc] init];
    [cell fillDataWithTitle:@"test"];
    return cell;
}

- (NSInteger)numberOfMenuCellsInDownListMenu:(CPDownListMenu *)downListMenu
{
    return 2;
}

- (NSInteger)downListMenu:(CPDownListMenu *)downListMenu numberOfCellsAtMenuIndex:(NSInteger)index
{
    if (index == 0) {
           return _data1List.count;
    }
    return _data2List.count;
}

- (UITableViewCell *)downListMenu:(CPDownListMenu *)downListMenu cellAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [downListMenu dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        cell.textLabel.text = _data1List[indexPath.row];
        return cell;
    }
    UITableViewCell *cell = [downListMenu dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = _data2List[indexPath.row];
    return cell;

}

@end
