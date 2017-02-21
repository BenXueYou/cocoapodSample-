//
//  WQTableViewItemsModel.m
//  MessageGroups
//
//  Created by YuMing on 16/3/28.
//  Copyright © 2016年 JAsolar. All rights reserved.
//

#import "WQItemModel.h"

@implementation WQItemModel
//图片标题副标题
+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title subTitle:(NSString *)subTitle
{
    WQItemModel *item = [self new];
    item.icon = icon;
    item.title = title;
    item.subTitle = subTitle;
    return item;
}
//图片与标题
+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title
{
    return [self itemWithIcon:icon title:title subTitle:nil];
}
//标题
+ (instancetype)itemWithTitle:(NSString *)title
{
    return [self itemWithIcon:nil title:title];
}
@end
