//
//  QCCalendarDataSource.m
//  cocoapodSample
//
//  Created by cnc on 16/9/8.
//  Copyright © 2016年 QC-朋学友. All rights reserved.
//

#import "QCCalendarDataSource.h"
#import "CalendarDayModel.h"
#import "weekModel.h"

@interface QCCalendarDataSource ()
@property (nonatomic,strong) CalendarDayModel *calendarDayModel;
@end

@implementation QCCalendarDataSource


-(NSMutableArray *)dataSource{
    
    if (!_dataSource) {
        _dataSource = [self loadArrayBeforeCurrent];
    }
    
    //    排序
    [_dataSource sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        weekModel *model1 = (weekModel *)obj1;
        weekModel *model2 = (weekModel *)obj2;
        
        return (model1.weekCount<model2.weekCount);
    }];

       return _dataSource;
}


-(NSMutableArray *)loadModelArray{
    
    NSMutableArray *modelArray = [NSMutableArray array];
    
    
    weekModel *model = [self getWeekModelWithCurrentDate:self.calendarDayModel];
    
    weekModel *WKModel = [[weekModel alloc] init];
    
    WKModel.weekCount = model.weekCount;
    WKModel.beginDate = model.beginDate;
    WKModel.endDate = model.endDate;
    
    [modelArray addObject:WKModel];
    
    while (model.weekCount < 53) {
        
        model.weekCount++;
        
        NSDate *beginDate = [[[NSDate date] dateFromString:model.beginDate] dayInTheFollowingDay:7];
        model.beginDate =[[NSDate date] stringFromDate:beginDate];
        
        NSDate *endDate = [[[NSDate date] dateFromString:model.beginDate] dayInTheFollowingDay:6];
        model.endDate =[[NSDate date] stringFromDate:endDate];
        
        weekModel *WKModel = [[weekModel alloc]init];
        WKModel.weekCount = model.weekCount;
        WKModel.beginDate = [NSString stringWithFormat:@"%@",model.beginDate];
        WKModel.endDate = [NSString stringWithFormat:@"%@",model.endDate];
        
        [modelArray addObject:WKModel];
        
        
    }
    
    return modelArray;
}


-(NSMutableArray *)loadArrayBeforeCurrent{
    
    NSMutableArray *modelArray = [NSMutableArray array];
    weekModel *model = [self getWeekModelWithCurrentDate:self.calendarDayModel];
    
    weekModel *WKModel = [[weekModel alloc] init];
    
    WKModel.weekCount = model.weekCount;
    WKModel.beginDate = model.beginDate;
    WKModel.endDate = model.endDate;
    
    [modelArray addObject:WKModel];

    
    while (model.weekCount > 1){
        
        model.weekCount--;
        
        NSDate *beginDate = [[[NSDate date] dateFromString:model.beginDate] dayInTheFollowingDay:-7];
        
        model.year = [beginDate YMDComponents].year;
        
        model.beginDate =[[NSDate date] stringFromDate:beginDate];
        
        NSDate *endDate = [[[NSDate date] dateFromString:model.endDate] dayInTheFollowingDay:-7];
        model.endDate =[[NSDate date] stringFromDate:endDate];
        
        
        weekModel *WKModel = [[weekModel alloc]init];
        
        WKModel.weekCount = model.weekCount;
        WKModel.beginDate = [NSString stringWithFormat:@"%@",model.beginDate];
        WKModel.endDate = [NSString stringWithFormat:@"%@",model.endDate];
        
        WKModel.year = model.year;
        
        NSLog(@"~~~~~~~~~~~~~~~~~~~~~~%ld",WKModel.weekCount);
        
        [modelArray addObject:WKModel];
        
      
        
    } ;
    
    
    return modelArray;
}

-(weekModel *)getWeekModelWithCurrentDate:(CalendarDayModel *)model{
    
    weekModel *WKModel = [[weekModel alloc]init];
    
    NSInteger month = model.month;
    NSInteger weekDay = [model.date getWeekIntValueWithDate];
    NSInteger week = [[NSCalendar currentCalendar]ordinalityOfUnit:NSWeekCalendarUnit inUnit:NSCalendarUnitYear forDate:model.date];
    
    WKModel.weekCount = week;
    
    NSString *str1 = [[NSDate date] stringFromDate:[model.date dayInTheFollowingDay:-(int)weekDay + 1]];
    NSString *str2 = [[NSDate date] stringFromDate:[model.date dayInTheFollowingDay:-(int)(weekDay - 7)]];
    
    WKModel.beginDate = [NSString stringWithFormat:@"%@",str1];
    WKModel.endDate = [NSString stringWithFormat:@"%@",str2];
    
    return WKModel;
}


-(CalendarDayModel *)calendarDayModel{
    
    
    if (!_calendarDayModel) {
        
        _calendarDayModel = [[CalendarDayModel alloc]init];
    }
        NSDate *currentDate = [NSDate date];
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:currentDate]; //
        
        [components month]; //gives you month
        [components day]; //gives you day
        [components year];
        [components weekday];
    
        _calendarDayModel = [CalendarDayModel calendarDayWithYear:components.year month:components.month day:components.day];
    
    return _calendarDayModel;
}

@end
