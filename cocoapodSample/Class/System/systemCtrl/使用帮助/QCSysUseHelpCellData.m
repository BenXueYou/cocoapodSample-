//
//  QCSysUseHelpCellData.m
//  cocoapodSample
//
//  Created by cnc on 16/9/6.
//  Copyright © 2016年 QC-朋学友. All rights reserved.
//

#import "QCSysUseHelpCellData.h"

__strong static QCSysUseHelpCellData *sys_help = nil;

@interface QCSysUseHelpCellData ()

@property (nonatomic,strong) NSMutableArray *homeStringArray;
@property (nonatomic,strong) NSMutableArray *checkStringArray;
@property (nonatomic,strong) NSMutableArray *systemStringArray;
@end
@implementation QCSysUseHelpCellData
+ (QCSysUseHelpCellData *)shareInstance{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sys_help = [[super allocWithZone:NULL] init];
    });
    return sys_help;
}

- (NSMutableArray *)cellDataWithStrng{

    NSMutableArray *array = [NSMutableArray array];
    
    [array addObjectsFromArray:@[self.homeStringArray,self.checkStringArray,self.systemStringArray]];
    
    return array ;
}

-(NSMutableArray *)homeStringArray{

    NSMutableArray *array = [NSMutableArray array];
    
    NSString *homeString1 = @"1.首页模块中：\n   >左上角有一个区域筛选按钮，可以选择不同的区域总览当前信息，包含有三项信息展示：当前区域站点运营情况总览、近期收入、桩的状态统计。 \n   >同时支持下拉刷新功能，实现当前的实时数据刷新。";
    NSString *homestring2 = @"2.运营情况总览分别有：今日统计、累计统计。\n   >今日统计：统计今日的收入以及充电量；\n  >累计统计：建桩以来的运营收入和输出的充电电量 \n   >账号信息：当前运营账号的权限等级——当前运营规模，点击icon可以进入到系统管理模块。";
    NSString *homeString3 = @"3.近期收入：点击进入 \n   >可以看到当前本周的收入统计的柱状图，同时还有当前周的桩运营情况的排榜—当前运营情况最好的桩与最差的桩。\n   >右上角有一个周历，可以定位到某一周的运营数据的统计。";
    NSString *homeString4 = @"4.桩统计：统计出当前站点的桩总数，与故障桩的总数。\n   >点击icon，进入二级列表页，提供的服务有：搜索查桩，状态筛选。\n   >根据输入或选择的状态条件，列出你想要的桩列表，列表中同时配有当前状态桩的详情页。";
    
    
    [array addObjectsFromArray:@[homeString1,homestring2,homeString3,homeString4]];
    
    return array;
}


-(NSMutableArray *)checkStringArray{
    
    NSMutableArray *array = [NSMutableArray array];
    
    NSString *checkString1 = @"1.查询模块：\n   >有账单记录和故障记录：有默认的最新的十条记录，同时支持下拉刷新的功能，刷新最新数据，上拉刷新数据：以当前的时间点向前的10条记录。";
    NSString *checkstring2 = @"2.右上角有一个搜索按钮，可以进入搜索界面，根据选择的条件，搜索想要的信息。";
    NSString *checkString3 = @"3.每条记录点击，进入详情页，展示当条记录详细信息。";
    
    
    [array addObjectsFromArray:@[checkString1,checkstring2,checkString3]];
    
    return array;
}

-(NSMutableArray *)systemStringArray{
    
    NSMutableArray *array = [NSMutableArray array];
    
    NSString *systemString1 = @"1.个人资料：有个人信息和账号信息的修改。";
    NSString *systemstring2 = @"2.我的消息：有超级管理员推送的消息，以及恢复的消息记录。";
    NSString *systemString3 = @"3.清除缓存：清除手机APP内缓存的冗余数据信息。";
    NSString *systemString4 = @"4.意见反馈：\n   >关于APP使用的意见或者建议，您可以反馈给开发者，我们非常感谢您对我们产品的支持。";
    NSString *systemString5 = @"5.使用帮助：希望对您的使用有一定的助力。";
    NSString *systemString6 = @"6.关于我们：对于本款APP你可以了解并联系我们。";
    
    [array addObjectsFromArray:@[systemString1,systemstring2,systemString3,systemString4,systemString5,systemString6]];
    
    return array;
}





@end
